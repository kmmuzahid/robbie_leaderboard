import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/screens/profile_screen/controller/profile_screen_controller.dart';
import 'package:the_leaderboard/screens/profile_screen/controller/shout_controller.dart';
import 'package:the_leaderboard/widgets/appbar_widget/appbar_widget.dart';
import 'package:the_leaderboard/widgets/button_widget/button_widget.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class ShoutScreen extends StatelessWidget {
  const ShoutScreen({super.key, this.isReadOnly = false});
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarWidget(
        title: 'Shout',
      ),
      backgroundColor: AppColors.blueDark,
      body: GetBuilder<ShoutController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget(
                      text: "Title",
                      fontColor: AppColors.greyLight,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    buildTextEdit(controller.shoutTitleController, false, 'Title', TextAlign.left),
                    const SizedBox(height: 10),
                    const TextWidget(
                      text: "Details",
                      fontColor: AppColors.greyLight,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    SizedBox(
                      height: 200,
                      child: buildTextEdit(
                          controller.shoutContentController, true, 'Write Here', TextAlign.start),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ButtonWidget(
                          onPressed: controller.updateShout,
                          label: "Shout Now",
                          buttonWidth: double.infinity,
                          backgroundColor: AppColors.blueLighter),
                    ),
                  ],
                ),
        );
      }),
    );
  }

  buildTextEdit(
          TextEditingController controller, bool isExpand, String hintext, TextAlign textalign) =>
      TextField(
        controller: controller,
        expands: isExpand,
        keyboardType: TextInputType.text,
        textAlign: textalign,
        textAlignVertical: TextAlignVertical.top,
        minLines: isExpand ? null : 1,
        maxLines: isExpand ? null : 1,
        style: const TextStyle(color: AppColors.white),
        decoration: InputDecoration(
          filled: true,
          hintText: hintext,
          hintStyle: const TextStyle(color: AppColors.greyLight),
          fillColor: AppColors.blue,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      );
}
