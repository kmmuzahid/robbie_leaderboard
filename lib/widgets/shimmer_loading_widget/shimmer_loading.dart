import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_leaderboard/constants/app_colors.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading(
      {super.key,
      required this.width,
      required this.height,
      this.margin = const EdgeInsetsGeometry.all(8),
      this.padding = const EdgeInsets.all(8),
      this.decoration = const BoxDecoration(
        color: AppColors.black,
      )});
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Decoration decoration;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColors.greyDark,
        highlightColor: AppColors.greyDarker,
        child: Container(
          width: width,
          height: height,
          margin: margin,
          padding: padding,
          decoration: decoration,
        ));
  }
}
