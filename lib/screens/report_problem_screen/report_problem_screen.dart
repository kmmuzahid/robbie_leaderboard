import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
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
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() async{
    try {
  final response = await ApiPostService.sentReport(_controller.text);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(response),
      duration: const Duration(seconds: 2),
    ),    
  );
  _controller.clear();
}  catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Error, Something went wrong"),
      duration: Duration(seconds: 2),
    ),
  );
}
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.blueDark,
        appBar: const AppbarWidget(title: "Report Problems", centerTitle: true),
        body: Padding(
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
                controller: _controller,
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
                onPressed: _sendMessage,
                label: "Send Message",
                buttonWidth: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
