import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_leaderboard/screens/faq_screen/widgets/faq_card.dart';

import '../../constants/app_colors.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.blueDark,
        appBar: const AppbarWidget(title: "FAQ’s", centerTitle: true),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: 5,
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: FAQCard(
                questionText: "Q: What is Westfert Basketball?",
                answerText:
                    "A: Westfert Basketball is a platform that allows users to participate in basketball-related activities, including betting and fantasy leagues.",
              ),
            );
          },
        ),
      ),
    );
  }
}
