import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/utils/app_size.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_image_path.dart';
import '../../widgets/image_widget/image_widget.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SplashController(),
        builder: (splashController) {
          return AnnotatedRegion(
            value: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
            ),
            child: Scaffold(
              backgroundColor: AppColors.blueDark,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ImageWidget(
                    imagePath: AppImagePath.appLogoNew,
                    height: AppSize.height(value: 500),
                    width: AppSize.width(value: 500),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
