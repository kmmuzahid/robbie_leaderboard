import 'package:flutter/material.dart';

import '../../utils/app_size.dart';

class ImageWidget extends StatelessWidget {
  final double height;
  final double width;
  final String imagePath;
  final BoxFit fit;
  final Color? color;

  const ImageWidget({
    super.key,
    required this.height,
    required this.width,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      height: ResponsiveUtils.width(height),
      width: ResponsiveUtils.width(width),
      fit: fit,
      color: color,
    );
  }
}
