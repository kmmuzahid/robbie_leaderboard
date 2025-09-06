import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/widgets/gradient_text_widget/gradient_text_widget.dart';

import '../../constants/app_colors.dart';
import '../../utils/app_size.dart';
import '../text_widget/text_widgets.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Widget? action;
  final PreferredSizeWidget? bottom;
  final String? title;
  final bool? centerTitle; // Add centerTitle property
  final Color? backgroundColor;
  final Widget? leading;
  final bool showLeading;

  const AppbarWidget({
    super.key,
    this.action,
    this.bottom,
    this.title,
    this.centerTitle, // Add centerTitle to constructor
    this.backgroundColor,
    this.leading,
    this.showLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: Container(color: backgroundColor ?? AppColors.blueDark),
      //titleSpacing: showLeading ? 1 : -35,
      leading: (leading ??
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.blueLighter,
              size: 20,
            ),
          )),

      titleSpacing: 10,
      actions: action != null ? [action!] : null,
      title: GradientText(
        text: title!,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bottom: bottom,
      // Add bottom to AppBar
      centerTitle: centerTitle, // Set centerTitle in AppBar
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
