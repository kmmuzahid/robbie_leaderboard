import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/gradient_text_widget/gradient_text_widget.dart';
import '../../../widgets/image_widget/image_widget.dart';
import '../../../widgets/space_widget/space_widget.dart';
import '../../../widgets/text_widget/text_widgets.dart';

class HallOfFameCardWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String status;
  final String title;
  final String type;

  const HallOfFameCardWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.status,
    this.title = '',
    this.type = '',
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Get screen width safely
        final screenWidth = MediaQuery.of(context).size.width;
        // Calculate a safe width value (35% of screen width)
        final cardWidth = screenWidth * 0.35;

        return Container(
          width: cardWidth,
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              GradientText(
                text: title,
                maxLines: 2,
                textAlign: TextAlign.center,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                colors: const [
                  AppColors.gradientColorStart,
                  AppColors.gradientColorEnd,
                ],
              ),
              const SpaceWidget(spaceHeight: 12),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: ImageWidget(
                      imagePath: imageUrl,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.gradientColorStart,
                            AppColors.gradientColorEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: TextWidget(
                          text: type,
                          fontColor: AppColors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          textAlignment: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SpaceWidget(spaceHeight: 16),
              SizedBox(
                width: ResponsiveUtils.width(200),
                child: TextWidget(
                  text: name,
                  fontColor: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textAlignment: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SpaceWidget(spaceHeight: 2),
              SizedBox(
                width: ResponsiveUtils.width(200),
                child: GradientText(
                  text: status,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
