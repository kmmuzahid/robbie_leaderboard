import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/screens/auth_screens/register_screen/controller/register_screen_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_html/flutter_html.dart';
Future<bool?> showTermsDialog(BuildContext context, RegisterScreenController _controller) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(color: Colors.black),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: GetBuilder<RegisterScreenController>(
            init: _controller,
            builder: (controller) {
              if (controller.isTermsAndCondtiosnLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = controller.termAndCondition.value;
              if (data.isEmpty) {
                return const Center(
                  child: Text(
                    "There are no terms and conditions",
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Html(
                  data: data,
                  style: {
                    "a": Style(
                      color: Colors.blue,
                      textDecoration: TextDecoration.underline,
                    ),
                    "*": Style(
                      color: Colors.black,
                    ),
                  },
                  onLinkTap: (url, attributes, element) {
                    if (url != null) {
                      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                    }
                  },
                  // onLinkTap: (url, _, __, ___) {
                  //   if (url != null) {
                  //     launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                  //   }
                  // },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text(
              'Decline',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text(
              'Accept',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      );
    },
  );
}
