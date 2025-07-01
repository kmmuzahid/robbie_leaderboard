import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../utils/app_size.dart';

class AuthAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;

  const AuthAppbarWidget({
    super.key,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveUtils.initialize(context);
    return AppBar(
      toolbarHeight: 100,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: Container(color: AppColors.blueDark),
      leadingWidth: 70,
      
      // Increased to accommodate larger CircleAvatar
      leading: Padding(
        padding: const EdgeInsets.only(top: 8, left: 16),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.black,
          child: leading ??
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.blueLighter,
                  size: 22,
                ),
              ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100.0);
}
