import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/api/api_patch_service.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class ShoutController extends GetxController {
  late TextEditingController shoutTitleController;
  late TextEditingController shoutContentController;
  bool isShouting = false;
  bool isLoading = false;

  fetch() async {
    isLoading = true;
    update();
    final url = "${AppUrls.otherUserProfile}/${StorageService.userId}";

    final response = await ApiGetService.apiGetService(url);
    isLoading = false;
    update();
    try {
      if (response != null) {
        final jsonbody = jsonDecode(response.body);

        if (response.statusCode == 200) {
          final shout = jsonbody['data']['shout'];
          if (shout != null) {
            shoutTitleController.text = shout['title'];
            shoutContentController.text = shout['description'];
          }
        }
      }
    } catch (_) {}
  }

  updateShout({bool showMessge = true}) async {
    if (isShouting || shoutContentController.text.isEmpty || shoutTitleController.text.isEmpty) {
      return;
    }
    isShouting = true;
    update();
    final result = await ApiPatchService.sendRequest(
        url: AppUrls.shout,
        body: {"title": shoutTitleController.text, "description": shoutContentController.text});
    isShouting = false;
    if (result.body.isEmpty) return;
    final data = jsonDecode(result.body);
    if (showMessge) {
      if (result.statusCode == 200) {
        Get.back();
        Get.snackbar('Success', data['message'] ?? '');
      } else {
        Get.snackbar('Faild!', data['message'] ?? '');
      }
    }
    update();
  }

  @override
  void dispose() {
    shoutTitleController.dispose();
    shoutContentController.dispose();

    super.dispose();
  }

  @override
  void onInit() {
    shoutTitleController = TextEditingController();
    shoutContentController = TextEditingController();
    fetch();

    super.onInit();
  }
}
