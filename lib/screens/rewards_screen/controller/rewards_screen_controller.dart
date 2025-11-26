import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:intl/intl.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/current_ruffle_model.dart';
import 'package:the_leaderboard/models/user_ticket_model.dart';
import 'package:the_leaderboard/screens/home_screen/controller/home_screen_controller.dart';
import 'package:the_leaderboard/screens/notification_screen/controller/notification_controller.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
import 'package:the_leaderboard/services/socket/socket_service.dart';
import 'package:the_leaderboard/services/storage/storage_keys.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class RewardsScreenController extends GetxController {
  // Timer to detect when wheel stops
  Timer? wheelStopTimer;
  DateTime lastWheelUpdate = DateTime.now();
  // Removed debouncer as it's no longer needed
  final Rxn<CurrentRuffleModel> currentRuffle = Rxn<CurrentRuffleModel>();
  final Rxn<UserTicketsModel> userTicket = Rxn<UserTicketsModel>();
  final RxBool isRuffleLoading = true.obs;
  final RxBool isTicketLoading = true.obs;
  final RxInt currentWheelIndex = 0.obs;
  final FixedExtentScrollController wheelController = FixedExtentScrollController();
  final RxInt dayIndex = 0.obs;
  final RxBool isSpinButtonActivate = true.obs;
  final RxString today = ''.obs;
  final RxInt totalTicket = 0.obs;
  final notificationController = Get.find<NotificationController>();
  final RxList<int> allSpin = [1, 2, 3, 4, 5, 10, 25, 50, 100, 250, 500, 1000].obs;
  final RxList<int> spinList = <int>[].obs;
  final luckyTicket = 0.obs;
  final isRotated = true.obs;
  // final responseMessage = "".obs;
  // final responseStatus = "".obs;
  final isLocked = false.obs;
  void fetchRuffle({bool isUpdating = false}) async {
    try {
      appLog("fetching ruffle");
      isRuffleLoading.value = isUpdating ? false : true;
      final response = await ApiGetService.apiGetService(AppUrls.currentRuffle);
      isRuffleLoading.value = false;
      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          currentRuffle.value = CurrentRuffleModel.fromJson(jsonbody["data"]);

          return;
        } else {
          Get.snackbar(
            "Error",
            jsonbody["message"],
            colorText: AppColors.white,
          );
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

  Future<void> fetchUserTicket({bool isUpdating = false}) async {
    try {
      isTicketLoading.value = isUpdating ? false : true;
      final response = await ApiGetService.apiGetService(AppUrls.myTicket);
      isTicketLoading.value = false;
      if (response != null) {
        final jsonbody = jsonDecode(response.body);
        totalTicket.value = 0;
        if (response.statusCode == 200) {
          userTicket.value = UserTicketsModel.fromJson(jsonbody["data"]);
          totalTicket.value = userTicket.value?.totalTickets ?? 0;
          dayIndex.value = userTicket.value?.spinCount ?? 0;
          appLog(userTicket);
          return;
        } else {
          Get.snackbar(
            "Error",
            jsonbody["message"],
            colorText: AppColors.white,
          );
        }
      }
    } catch (e) {
      errorLog("fetchUserTicket", e);
    }
    userTicket.value = UserTicketsModel(
        totalTickets: 0, userId: "Unknown", name: "Unknown", tickets: [], spinCount: 0);
    return;
  }

  Future fetchData({bool isUpdating = false}) async {
    fetchRuffle(isUpdating: isUpdating);
    await fetchUserTicket(isUpdating: isUpdating);
    if (dayIndex.value > 7) {
      dayIndex.value = 0;
    }
    allSpin.shuffle();
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

  // Future<void> createTicket() async {
  //   try {
  //     final response = await ApiPostService.apiPostService(AppUrls.createTicket, {});

  //     if (response != null) {
  //       appLog(response.body);
  //       final data = jsonDecode(response.body);

  //       if (response.statusCode == 200 || response.statusCode == 201) {
  //         if (data['data'] != null) {
  //           luckyTicket.value = data['data']['ticket'] ?? 0;
  //           appLog("The lucky number is ${luckyTicket.value}");
  //           SocketService.instance.createTicket(StorageService.myName, data["data"]);
  //           responseStatus.value = "Success";
  //           responseMessage.value = "${luckyTicket.value} Tickets created successfully";
  //         }
  //       } else {
  //         responseStatus.value = "Failed";
  //         responseMessage.value = data["message"];
  //       }
  //     }
  //   } catch (e) {
  //     appLog("Error in creating ticket: $e");
  //   }
  // }

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

  bool isSpining = false;
  DateTime? _lastSpinTime;
  bool _isProcessingSpin = false;

  void spinWheel(bool fromButton) async {
    // Prevent multiple simultaneous spins

    if (isSpining || _isProcessingSpin) return;

    // Check cooldown (1 second)
    final now = DateTime.now();
    if (_lastSpinTime != null && now.difference(_lastSpinTime!) < const Duration(seconds: 1)) {
      return;
    }

    _isProcessingSpin = true;
    isSpining = true;
    _lastSpinTime = now;

    try {
      final homeController = Get.find<HomeScreenController>();
      if (homeController.country.value.isEmpty || homeController.phone.value.isEmpty) {
        isLocked.value = true;
        Get.snackbar("Action Required", "Please update your Country and Phone Number to proceed.",
            colorText: AppColors.white);
        Get.toNamed('/editProfileScreen', arguments: {
          'onSuccess': () {
            if (!(homeController.country.value.isEmpty || homeController.phone.value.isEmpty)) {
              isLocked.value = false;
            }
          }
        });
        return;
      }

      // Make the API call
      final response = await ApiPostService.apiPostService(AppUrls.createTicket, {});

      if (response != null) {
        appLog(response.body);
        final data = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          dayIndex.value += 1;
          if (data['data'] != null) {
            luckyTicket.value = data['data']['ticket'] ?? 0;
            appLog("The lucky number is ${luckyTicket.value}");

            // Notify socket service
            SocketService.instance.createTicket(StorageService.myName, data["data"]);

            // Start the spinning animation
            isLocked.value = true;
            int rotations = 100;

            if (fromButton) {
              rotateWithButton(rotations);
            } else {
              spinToLuckyNumber();
            }

            // Update ticket count after spin completes
            Future.delayed(
              const Duration(seconds: 3),
              () {
                totalTicket.value += luckyTicket.value;
              },
            );
          }
        } else {
          isLocked.value = true;
          Get.snackbar(
            "Sorry!!",
            data["message"],
            colorText: AppColors.white,
          );
        }
      }
    } catch (e) {
      appLog("Error in creating ticket: $e");
      Get.snackbar(
        "Error",
        "Failed to process spin. Please try again.",
        colorText: AppColors.white,
      );
    } finally {
      _isProcessingSpin = false;
      isSpining = false;
      // Don't set isSpining to false here as it's used by the wheel animation
      // It will be set to false when the wheel animation completes
    }
  }

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

    appLog("Spinning to ${luckyTicket.value} with $rotations rotations in ${duration.inSeconds}s");

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
    super.onInit();
  }

  @override
  void onClose() {
    wheelStopTimer?.cancel();
    wheelController.dispose();
    super.onClose();
  }
}
