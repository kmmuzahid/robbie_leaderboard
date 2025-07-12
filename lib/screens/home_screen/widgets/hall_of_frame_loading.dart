import 'package:flutter/widgets.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/widgets/shimmer_loading_widget/shimmer_loading.dart';

class HallOfFrameLoading extends StatelessWidget {
  const HallOfFrameLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return ShimmerLoading(
      width: size * 0.35,
      height: 250,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
