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
    if (dayIndex.value == 7) {
      dayIndex.value = 0;
    }
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

  String getRemainingDays() {
    final deadline = currentRuffle.value!.deadline;
    final today = DateTime.now();
    final remaining = deadline.difference(today).inDays;
    if (remaining > 0) {
      return "${remaining.toString()} Days Remaining";
    } else {
      return "Deadline has already passed";
    }
  }

  void createTicket(int random) async {
    final quantity = currentRuffle.value!.ticketButtons[random];
    final response = await ApiPostService.apiPostService(
        AppUrls.createTicket, {"qty": quantity});

    if (response != null) {
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        SocketService.instance.createTicket(LocalStorage.myName, data["data"]);

        Get.snackbar("Success", data["message"], colorText: AppColors.white);
      } else {
        Get.snackbar("Success", data["message"], colorText: AppColors.white);
      }
    }
  }

  void spinWheel() {
    final today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    appLog(today);
    final lastwheelday = LocalStorage.lastWheelday;
    appLog(lastwheelday);
    // if (lastwheelday.isEmpty || today != lastwheelday) {
    final random =
        math.Random().nextInt(currentRuffle.value!.ticketButtons.length);
    currentWheelIndex.value = random;
    final totalItem = random + currentRuffle.value!.ticketButtons.length * 4;
    wheelController.animateToItem(totalItem,
        duration: const Duration(seconds: 3), curve: Curves.fastOutSlowIn);
    dayIndex.value++;
    LocalStorage.setString(LocalStorageKeys.lastWheelday, today);
    LocalStorage.lastWheelday = today;
    LocalStorage.dayIndex = dayIndex.value;
    LocalStorage.setInt(LocalStorageKeys.dayIndex, dayIndex.value);
    totalTicket.value += currentRuffle.value!.ticketButtons[random];
    LocalStorage.setInt(LocalStorageKeys.totalTicket, totalTicket.value);
    LocalStorage.totalTicket = totalTicket.value;
    createTicket(random);
    // } else {

    //   Get.snackbar(
    //       "You have reached the today's limit!", "Please try again tomorrow.",
    //       colorText: AppColors.white, snackPosition: SnackPosition.BOTTOM);
    // }
  }

  void spin2() {
    final today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final lastWheelDay = LocalStorage.lastWheelday;

    appLog("📅 Today: $today");
    appLog("🗓️ Last spin: $lastWheelDay");

    if (lastWheelDay.isNotEmpty && today == lastWheelDay) {
      Get.snackbar(
        "You have reached today's limit!",
        "Please try again tomorrow.",
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppColors.white,
      );
      return;
    }

    final itemCount = currentRuffle.value!.ticketButtons.length;
    final randomIndex = math.Random().nextInt(itemCount);
    currentWheelIndex.value = randomIndex;

    // Spin fast at first, then slow it down
    final totalItem = randomIndex + itemCount * 6; // Add loops for effect

    wheelController.animateToItem(
      totalItem,
      duration: const Duration(seconds: 3), // Slow spin duration
      curve: Curves.decelerate, // Fast → slow
    );

    // Save result after spin ends
    Future.delayed(const Duration(seconds: 3), () {
      final selectedIndex = randomIndex;
      final ticketEarned = currentRuffle.value!.ticketButtons[selectedIndex];

      // Store in totalTicket and local storage
      totalTicket.value += ticketEarned;
      LocalStorage.totalTicket = totalTicket.value;
      LocalStorage.setInt(LocalStorageKeys.totalTicket, totalTicket.value);

      // Store last spin info
      LocalStorage.lastWheelday = today;
      LocalStorage.setString(LocalStorageKeys.lastWheelday, today);

      dayIndex.value++;
      LocalStorage.dayIndex = dayIndex.value;
      LocalStorage.setInt(LocalStorageKeys.dayIndex, dayIndex.value);

      // Store last index or do anything you want with result
      createTicket(selectedIndex); // 🎫 Optional logic
      appLog("✅ Final selected ticket: $ticketEarned");
    });
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

  RxBool hasSpunOnGesture = false.obs;
  RxString selectedTicket = ''.obs;

  void spinOnceOnUserStart() {
    if (hasSpunOnGesture.value) return;

    hasSpunOnGesture.value = true;

    final itemCount = currentRuffle.value!.ticketButtons.length;
    final random = math.Random().nextInt(itemCount);
    currentWheelIndex.value = random;

    final totalItem = random + itemCount * 6;

    wheelController.animateToItem(
      totalItem,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );

    // Wait for animation to complete before resetting and getting result
    Future.delayed(const Duration(milliseconds: 1100), () {
      hasSpunOnGesture.value = false;

      final selectedIndex = wheelController.selectedItem % itemCount;
      final result = currentRuffle.value!.ticketButtons[selectedIndex];

      selectedTicket.value = result.toString();
      print("✅ Final selected ticket: $result");

      // TODO: Show a dialog, update UI, or call a success handler here
    });
  }

  RxString lastSelectedValue = ''.obs;
  Timer? _debounceTimer;
  void handleWheelValueChanged2(String value) {
    // Cancel previous debounce timer if still active
    _debounceTimer?.cancel();

    // Start new timer: if no change within 500ms, assume final value
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      lastSelectedValue.value = value;
      appLog("✅ Final selected value: $value");
      // Now you can store it, update UI, etc.
    });
  }

  void finalSpin(int value) {
    List values = [];
    values.add(value);
  }
}
