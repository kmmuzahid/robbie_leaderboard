import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/screens/profile_screen/controller/shout_controller.dart';
import 'package:the_leaderboard/widgets/button_widget/button_widget.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class ShoutWidget extends StatelessWidget {
  const ShoutWidget({Key? key, this.showShout = true}) : super(key: key);
  final bool showShout;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShoutController>(builder: (controller) {
      return controller.isLoading
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
                if (showShout)
                  Center(
                    child: ButtonWidget(
                        onPressed: controller.updateShout,
                        label: "Shout Now",
                        buttonWidth: double.infinity,
                        backgroundColor: AppColors.blueLighter),
                  ),
              ],
            );
    });
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
