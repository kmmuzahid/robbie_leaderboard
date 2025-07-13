import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:the_leaderboard/screens/faq_screen/controller/faq_screen_controller.dart';
import 'package:the_leaderboard/screens/faq_screen/widgets/faq_card.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

import '../../constants/app_colors.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: FaqScreenController(),
      builder: (controller) => AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.blueDark,
          appBar: const AppbarWidget(title: "FAQ’s", centerTitle: true),
          body: Obx(
            () => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.faqList.isEmpty
                    ? const Center(
                        child: TextWidget(
                          text: "There is no Frequently Asked Questions",
                          fontColor: AppColors.white,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        itemCount: controller.faqList.length,
                        itemBuilder: (context, index) {
                          final item = controller.faqList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: FAQCard(
                              questionText: "Q: ${item?.question}",
                              answerText: "A: ${item?.answer}",
                            ),
                          );
                        },
                      ),
          ),
        ),
      ),
    );
  }
}
