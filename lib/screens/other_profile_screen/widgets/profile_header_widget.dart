import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/image_widget/image_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String image;
  final String name;
  final String email;
  final bool fromNetwork;

  const ProfileHeaderWidget({
    super.key,
    required this.image,
    required this.name,
    required this.email,
    required this.fromNetwork
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          // Profile Picture
          ImageWidget(
            height: 60,
            width: 60,
            imagePath: image,
            fromNetwork: fromNetwork,
          ),
          const SpaceWidget(spaceHeight: 8),
          // Name
          TextWidget(
            text: name,
            fontColor: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          const SpaceWidget(spaceHeight: 2),
          // Email
          TextWidget(
            text: email,
            fontColor: AppColors.greyDarker,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          const SpaceWidget(spaceHeight: 16)
        ]));
    // Balance and Withdraw Button
  }
}
