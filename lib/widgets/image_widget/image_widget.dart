import 'package:flutter/material.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/widgets/image_widget/common_image.dart';

import '../../utils/app_size.dart';

class ImageWidget extends StatelessWidget {
  final double height;
  final double width;
  final String imagePath;
  final BoxFit fit;
  final Color? color;
  final bool? fromNetwork;

  const ImageWidget(
      {super.key,
      required this.height,
      required this.width,
      required this.imagePath,
      this.fit = BoxFit.cover,
      this.color,
      this.fromNetwork});

  @override
  Widget build(BuildContext context) {
    return CommonImage(
        imageSrc: imagePath, height: height, width: width, fill: fit, imageColor: color);
  }
}
