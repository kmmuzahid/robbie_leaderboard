import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:the_leaderboard/models/current_ruffle_model.dart';
import 'package:the_leaderboard/models/user_ticket_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
import 'package:the_leaderboard/services/storage/storage_keys.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

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
  final RxInt tototalTicket = 0.obs;

  void fetchData() async {
    isRuffleLoading.value = true;
    final responseRuffle = await ApiGetService.fetchCurrentRuffleData();
    if (responseRuffle != null) {
      currentRuffle.value = responseRuffle;
    }
    isRuffleLoading.value = false;

    isTicketLoading.value = true;
    final responseTicket = await ApiGetService.fetchUserTicket();
    if (responseTicket != null) {
      userTicket.value = responseTicket;
    }
    isTicketLoading.value = false;
    tototalTicket.value = LocalStorage.totalTicket;
    dayIndex.value = LocalStorage.dayIndex;
    today.value = LocalStorage.today;
    setspinButton();
    // LocalStorage.setString(LocalStorageKeys.today,
    //     DateFormat("yyyy-MM-dd").format(DateTime(2025, 7, 5)));
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

  void spinWheel() async {
    final random =
        math.Random().nextInt(currentRuffle.value!.ticketButtons.length);
    currentWheelIndex.value = random;
    wheelController.animateToItem(random,
        duration: const Duration(seconds: 3), curve: Curves.fastOutSlowIn);
    dayIndex.value++;
    today.value = DateFormat("yyyy-MM-dd").format(DateTime.now());
    LocalStorage.setString(LocalStorageKeys.today, today.value);
    LocalStorage.setInt(LocalStorageKeys.dayIndex, dayIndex.value);
    isSpinButtonActivate.value = false;
    tototalTicket.value += currentRuffle.value!.ticketButtons[random];
    LocalStorage.setInt(LocalStorageKeys.totalTicket, tototalTicket.value);
    await ApiPostService.createTicket(
        currentRuffle.value!.ticketButtons[random]);

    print("today is: ${LocalStorage.today}");
  }

  void setspinButton() {
//     LocalStorage.setString(LocalStorageKeys.today,
//         DateFormat("yyyy-MM-dd").format(DateTime(2025, 7, 6)));
//     LocalStorage.setInt(LocalStorageKeys.totalTicket, 0);
// LocalStorage.setInt(LocalStorageKeys.dayIndex, 0);
    final now = DateFormat("yyyy-MM-dd").format(DateTime.now());
    dayIndex.value = LocalStorage.dayIndex;
    today.value = LocalStorage.today;
    if (now == today.value && dayIndex.value < 7) {
      isSpinButtonActivate.value = false;
      Get.snackbar(
          "Error", "You have reached the today's limit. Try again tommorrow");
    } else if (now == today.value && dayIndex.value == 7) {
      isSpinButtonActivate.value = true;
      LocalStorage.setInt(LocalStorageKeys.dayIndex, 0);
    } else {
      isSpinButtonActivate.value = true;
    }
  }

  void spinWheelButton() {
    final today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final lastday = LocalStorage.today;
    print("$today, $lastday, ${dayIndex.value}");
    if (lastday.isEmpty) {
      spinWheel();
      LocalStorage.setString(LocalStorageKeys.today, today);
    } else if (today == lastday && dayIndex.value < 7) {
      Get.snackbar(
          "Error", "You have reached the today's limit. Try again tommorrow");
    } else if (today == lastday && dayIndex.value == 7) {
      spinWheel();
      LocalStorage.setString(LocalStorageKeys.today, today);
      LocalStorage.setInt(LocalStorageKeys.dayIndex, 0);
    }
    else{
       Get.snackbar(
          "Error", "You have reached the today's limit. Try again tommorrow");
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    wheelController.dispose();
  }
}
