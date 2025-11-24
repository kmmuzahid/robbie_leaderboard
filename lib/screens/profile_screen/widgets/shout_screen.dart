import 'package:flutter/material.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/screens/profile_screen/widgets/shout_widget.dart';
import 'package:the_leaderboard/widgets/appbar_widget/appbar_widget.dart';

class ShoutScreen extends StatelessWidget {
  const ShoutScreen({super.key, this.isReadOnly = false});
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppbarWidget(
        title: 'Shout',
      ),
      backgroundColor: AppColors.blueDark,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ShoutWidget(),
      ),
    );
  }

  
}
