import 'package:flutter/material.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_strings.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class ShowModalBottomSheetWidget extends StatelessWidget {
  const ShowModalBottomSheetWidget({
    super.key,
    required this.onTakePhoto,
    required this.onChooseFromGallery,
  });
  final void Function() onTakePhoto;
  final void Function() onChooseFromGallery;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Align(
                alignment: Alignment.centerLeft,
                child: TextWidget(
                  text: AppStrings.takePhoto,
                  fontColor: AppColors.black,
                  fontSize: 15,
                ),
              ),
              onTap: () {
                onTakePhoto();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Align(
                alignment: Alignment.centerLeft,
                child: TextWidget(
                  text: AppStrings.chooseFromGallery,
                  fontColor: AppColors.black,
                  fontSize: 15,
                ),
              ),
              onTap: () {
                onChooseFromGallery();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
