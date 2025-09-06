import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/current_ruffle_model.dart';
import 'package:the_leaderboard/models/user_ticket_model.dart';
import 'package:the_leaderboard/screens/notification_screen/controller/notification_controller.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
import 'package:the_leaderboard/services/socket/socket_service.dart';
import 'package:the_leaderboard/services/storage/storage_keys.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class RewardsScreenController extends GetxController {
  final Rxn<CurrentRuffleModel> currentRuffle = Rxn<CurrentRuffleModel>();
  final Rxn<UserTicketsModel> userTicket = Rxn<UserTicketsModel>();
  final RxBool isRuffleLoading = true.obs;
  final RxBool isTicketLoading = true.obs;
  final RxInt currentWheelIndex = 0.obs;
  final FixedExtentScrollController wheelController =
      FixedExtentScrollController();
  final RxInt dayIndex = 0.obs;
  final RxBool isSpinButtonActivate = true.obs;
  final RxString today = ''.obs;
  final RxInt totalTicket = 0.obs;
  final notificationController = Get.find<NotificationController>();
  final RxList<int> allSpin =
      [1, 2, 3, 4, 5, 10, 25, 50, 100, 250, 500, 1000].obs;
  final RxList<int> spinList = <int>[].obs;
  final luckyTicket = 0.obs;
  final isRotated = true.obs;
  final responseMessage = "".obs;
  final responseStatus = "".obs;
  void fetchRuffle() async {
    try {
      appLog("fetching ruffle");
      isRuffleLoading.value = true;
      final response = await ApiGetService.apiGetService(AppUrls.currentRuffle);
      isRuffleLoading.value = false;
      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          currentRuffle.value = CurrentRuffleModel.fromJson(jsonbody["data"]);
          return;
        } else {
          Get.snackbar("Error", jsonbody["message"],
              colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM);
        }
      }
    } catch (e) {
      errorLog("Failed", e);
    }
    final temp = CurrentRuffleModel(
        id: "0",
        deadline: DateTime(2000),
        prizeMoney: 0,
        ticketButtons: [],
        createdAt: DateTime(2000),
        updatedAt: DateTime(2000),
        v: 1);
    currentRuffle.value = temp;
    return;
  }

  void fetchUserTicket() async {
    try {
      appLog("fetching userticket");
      isTicketLoading.value = true;
      final response = await ApiGetService.apiGetService(AppUrls.myTicket);
      isTicketLoading.value = false;
      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          userTicket.value = UserTicketsModel.fromJson(jsonbody["data"]);
          appLog(userTicket);
          return;
        } else {
          Get.snackbar("Error", jsonbody["message"],
              colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM);
        }
      }
    } catch (e) {
      errorLog("fetchUserTicket", e);
    }
    userTicket.value = UserTicketsModel(
        totalTickets: 0, userId: "Unknown", name: "Unknown", tickets: []);
    return;
  }

  Future fetchData() async {
    fetchRuffle();
    fetchUserTicket();
    totalTicket.value = LocalStorage.totalTicket;
    dayIndex.value = LocalStorage.dayIndex;
    if (dayIndex.value > 7) {
      dayIndex.value = 0;
    }
    allSpin.shuffle();
    //temp
    // LocalStorage.totalTicket = 0;
    // LocalStorage.dayIndex = 0;
    // LocalStorage.lastWheelday =
    //     DateFormat("yyyy-MM-dd").format(DateTime(2025, 7, 11));
    // LocalStorage.setInt(LocalStorageKeys.totalTicket, 0);
    // LocalStorage.setInt(LocalStorageKeys.dayIndex, 0);
    // LocalStorage.setString(LocalStorageKeys.lastWheelday,
    //     DateFormat("yyyy-MM-dd").format(DateTime(2025, 7, 11)));
    //---end
  }

  String getRemainingTime() {
    final deadline = currentRuffle.value!.deadline;
    final now = DateTime.now();
    final diff = deadline.difference(now);

    if (diff.isNegative) {
      return "Deadline has already passed";
    } else if (diff.inDays >= 1) {
      return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} remaining";
    } else if (diff.inHours >= 1) {
      return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} remaining";
    } else if (diff.inMinutes >= 1) {
      return "${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} remaining";
    } else {
      return "${diff.inSeconds} second${diff.inSeconds != 1 ? 's' : ''} remaining";
    }
  }

  Future<void> createTicket() async {
    try {
      appLog("Now in create ticket");
      final response =
          await ApiPostService.apiPostService(AppUrls.createTicket, {});

      if (response != null) {
        appLog(response.body);
        final data = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          luckyTicket.value = data['data']['ticket'] ?? 0;
          appLog("The lucky number is ${luckyTicket.value}");
          SocketService.instance
              .createTicket(LocalStorage.myName, data["data"]);
          responseStatus.value = "Success";
          responseMessage.value =
              "${luckyTicket.value} Tickets created successfully";
          // Get.snackbar(
          //     "Success", "${luckyTicket.value} Tickets created successfully",
          //     colorText: AppColors.white);
        } else {
          responseStatus.value = "Failed";
          responseMessage.value = data["message"];
          // Get.snackbar("Success", data["message"], colorText: AppColors.white);
        }
      }
    } catch (e) {
      appLog("Error in creating ticket: $e");
    }
  }

  void rotateWithButton(int rotations) {
    int value = luckyTicket.value;
    int valueIndex = allSpin.indexOf(value);
    int targetIndex = ((rotations * allSpin.length) + valueIndex).toInt();
    appLog("Now in after create ticket and lucky number: $value");
    // final targetIndex = (allSpin.length * 10) + value;

    wheelController.animateToItem(
      targetIndex,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  void spinWheel(bool fromButton) async {
    final today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    appLog(today);
    final lastwheelday = LocalStorage.lastWheelday;
    appLog(lastwheelday);
    if (getRemainingTime() == "Deadline has already passed") {
      Get.snackbar("Deadline Passed",
          "The deadline has already passed. Please check the date.",
          colorText: AppColors.white);
      return;
    }

    if (lastwheelday.isEmpty || today != lastwheelday) {
      await createTicket();

      int rotations = 100;
      int value = luckyTicket.value;
      if (fromButton) {
        rotateWithButton(rotations);
      } else {
        spinToLuckyNumber();
      }
      // allSpin.shuffle();
      // final random =
      //     math.Random().nextInt(currentRuffle.value!.ticketButtons.length);
      // currentWheelIndex.value = random;
      // final totalItem = random + currentRuffle.value!.ticketButtons.length * 4;
      // wheelController.animateToItem(totalItem,
      //     duration: const Duration(seconds: 3), curve: Curves.fastOutSlowIn);
      dayIndex.value++;
      LocalStorage.setString(LocalStorageKeys.lastWheelday, today);
      LocalStorage.lastWheelday = today;
      LocalStorage.dayIndex = dayIndex.value;
      LocalStorage.setInt(LocalStorageKeys.dayIndex, dayIndex.value);
      totalTicket.value += value;
      LocalStorage.setInt(LocalStorageKeys.totalTicket, totalTicket.value);
      LocalStorage.totalTicket = totalTicket.value;
      Future.delayed(
        const Duration(seconds: 3),
        () {
          Get.snackbar(responseStatus.value, responseMessage.value,
              colorText: AppColors.white);
        },
      );

      // createTicket();
    } else {
      Get.snackbar(
        "Limit Reached",
        "You've reached today's limit. Please come back tomorrow!",
        colorText: AppColors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // fast spin or slow spin
  DateTime? _lastSpinTime;

  /// Detect speed and return type
  String detectSpinSpeed() {
    final now = DateTime.now();

    if (_lastSpinTime == null) {
      _lastSpinTime = now;
      return "normal";
    }

    final diff = now.difference(_lastSpinTime!).inMilliseconds;
    _lastSpinTime = now;

    if (diff < 150) {
      return "fast";
    } else if (diff < 400) {
      return "medium";
    } else {
      return "slow";
    }
  }

  /// Spin logic with adaptive duration & rotations
  void spinToLuckyNumber() {
    int valueIndex = allSpin.indexOf(luckyTicket.value);

    // detect speed
    String speed = detectSpinSpeed();
    appLog("Detected spin speed: $speed");

    int rotations;
    Duration duration;

    switch (speed) {
      case "fast":
        rotations = 100;
        duration = const Duration(seconds: 1);
        break;
      case "medium":
        rotations = 80;
        duration = const Duration(seconds: 2);
        break;
      case "slow":
      default:
        rotations = 60;
        duration = const Duration(seconds: 3);
        break;
    }

    int targetIndex = (rotations * allSpin.length) + valueIndex;

    appLog(
        "Spinning to ${luckyTicket.value} with $rotations rotations in ${duration.inSeconds}s");

    wheelController.animateToItem(
      targetIndex,
      duration: duration,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchData();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    wheelController.dispose();
  }
}
