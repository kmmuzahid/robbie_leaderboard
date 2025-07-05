import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:the_leaderboard/models/current_ruffle_model.dart';
import 'package:the_leaderboard/models/user_ticket_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
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
    setspinButton();
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

  void spinWheel() {
    final random =
        math.Random().nextInt(currentRuffle.value!.ticketButtons.length);
    currentWheelIndex.value = random;
    wheelController.animateToItem(random,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    dayIndex.value++;
    today.value = DateFormat("yyyy-MM-dd").format(DateTime.now());
    LocalStorage.setString(LocalStorageKeys.today, today.value);
    LocalStorage.setInt(LocalStorageKeys.dayIndex, dayIndex.value);
    isSpinButtonActivate.value = false;
    tototalTicket.value += currentRuffle.value!.ticketButtons[random];
  }

  void setspinButton() {
    // LocalStorage.setString(LocalStorageKeys.today,
    //     DateFormat("yyyy-MM-dd").format(DateTime(2025, 5, 6)));
    final now = DateFormat("yyyy-MM-dd").format(DateTime.now());
    dayIndex.value = LocalStorage.dayIndex;
    today.value = LocalStorage.today;
    if (now == today.value && dayIndex.value < 7) {
      isSpinButtonActivate.value = false;
    } else if (now == today.value && dayIndex.value == 7) {
      isSpinButtonActivate.value = true;
      LocalStorage.setInt(LocalStorageKeys.dayIndex, 0);
    } else {
      isSpinButtonActivate.value = true;
    }
  }
}
