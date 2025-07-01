import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_image_path.dart';
import '../../widgets/image_widget/image_widget.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final splashController = Get.put(SplashController());

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.blueDark,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: ImageWidget(
              imagePath: AppImagePath.appLogoGold,
              height: 180,
              width: 150,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
