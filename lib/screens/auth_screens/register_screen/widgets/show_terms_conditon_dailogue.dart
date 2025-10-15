import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/screens/auth_screens/register_screen/controller/register_screen_controller.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool?> showTermsDialog(BuildContext context, RegisterScreenController _controller) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // Force user to accept or decline
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black87, // Or your preferred color
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400, // adjust height as needed
          child: Obx(() {
            if (_controller.isTermsAndCondtiosnLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = _controller.termAndCondition.value;
            if (data.isEmpty) {
              return const Center(
                child: Text(
                  "There is no term and condition",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: HtmlWidget(
                data,
                textStyle: const TextStyle(color: Colors.white),
                onTapUrl: (url) => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
              ),
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // User declines
            },
            child: const Text(
              'Decline',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true); // User accepts
            },
            child: const Text('Accept'),
          ),
        ],
      );
    },
  );
}
