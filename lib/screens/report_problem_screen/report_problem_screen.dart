import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/screens/report_problem_screen/controller/report_problem_controller.dart';
import 'package:the_leaderboard/widgets/button_widget/button_widget.dart';
import '../../constants/app_colors.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';
import '../../widgets/space_widget/space_widget.dart';
import '../../widgets/text_widget/text_widgets.dart';

class ReportProblemsScreen extends StatefulWidget {
  const ReportProblemsScreen({super.key});

  @override
  _ReportProblemsScreenState createState() => _ReportProblemsScreenState();
}

class _ReportProblemsScreenState extends State<ReportProblemsScreen> {
  final _controller = Get.put(ReportProblemController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.blueDark,
        appBar: const AppbarWidget(title: "Report Problem", centerTitle: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextWidget(
                  text: "Write down the problem you are facing",
                  fontColor: AppColors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                const SpaceWidget(spaceHeight: 16),
                TextFormField(
                  controller: _controller.textController,
                  maxLines: 15,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.blue,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SpaceWidget(spaceHeight: 24),
                ButtonWidget(
                  onPressed: _controller.sendMessage,
                  label: "Send Message",
                  buttonWidth: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
