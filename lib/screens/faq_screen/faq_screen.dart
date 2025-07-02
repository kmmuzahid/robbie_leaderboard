import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:the_leaderboard/screens/faq_screen/controller/faq_screen_controller.dart';
import 'package:the_leaderboard/screens/faq_screen/widgets/faq_card.dart';

import '../../constants/app_colors.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final _controller = Get.put(FaqScreenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.blueDark,
        appBar: const AppbarWidget(title: "FAQ’s", centerTitle: true),
        body: Obx(
          ()=> ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: _controller.faqList.length,
            itemBuilder: (context, index) {
              final item = _controller.faqList[index];
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
    );
  }
}
