import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  Future<void> onInitialDataLoadFunction() async {
    try {
      await Future.delayed(Duration(seconds: 2));

      if (LocalStorage.token.isEmpty) {
        Get.offAllNamed(AppRoutes.onboardingScreen);
      } else {
        Get.offAllNamed(AppRoutes.appNavigation);
      }
    } catch (e) {
      errorLog("onInitialDataLoadFunction", e);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        // Get.offAllNamed(AppRoutes.err)
      });
    }
  }

  @override
  void onInit() {
    onInitialDataLoadFunction();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    print("Splash Controller disposed"); // Log message to confirm disposal
  }
}
