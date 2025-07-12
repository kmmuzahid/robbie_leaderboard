import 'package:flutter/widgets.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/utils/app_size.dart';
import 'package:the_leaderboard/widgets/shimmer_loading_widget/shimmer_loading.dart';

class ProfileCardLoading extends StatelessWidget {
  const ProfileCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      width: AppSize.size.width,
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
