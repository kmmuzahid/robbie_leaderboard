import 'package:flutter/material.dart';

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
    if (fromNetwork != null && fromNetwork == true) {
      return Image.network(
        imagePath,
        height: ResponsiveUtils.width(height),
        width: ResponsiveUtils.width(width),
        fit: fit,
        color: color,
      );
    }
    return Image.asset(
      imagePath,
      height: ResponsiveUtils.width(height),
      width: ResponsiveUtils.width(width),
      fit: fit,
      color: color,
    );
  }
}
