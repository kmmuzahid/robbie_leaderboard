import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/screens/withdraw_amount_screen/controller/withdraw_amount_controller.dart';
import 'package:the_leaderboard/widgets/appbar_widget/appbar_widget.dart';
import 'package:the_leaderboard/widgets/button_widget/button_widget.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class WithdrawAmountScreen extends StatefulWidget {
  const WithdrawAmountScreen({super.key});

  @override
  State<WithdrawAmountScreen> createState() => _WithdrawAmountScreenState();
}

class _WithdrawAmountScreenState extends State<WithdrawAmountScreen> {
  final _controller = Get.put(WithdrawAmountController());
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: label,
          fontColor: AppColors.greyLight,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        const SpaceWidget(spaceHeight: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.blue,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.blueDark,
        appBar: const AppbarWidget(title: ""),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: _buildTextField(
            label: "Enter amount",
            controller: _controller.amountController,
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ButtonWidget(
            onPressed: _controller.submit,
            label: "Withdraw",
            buttonWidth: double.infinity,
          ),
        ),
      ),
    );
  }
}
