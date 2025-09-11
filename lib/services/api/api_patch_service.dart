import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class ApiPatchService {
  // static Future<void> updateProfile(
  //     String? name,
  //     String? contact,
  //     String? country,
  //     String? city,
  //     String? gender,
  //     String? age,
  //     String? facebook,
  //     String? instagram,
  //     String? twitter,
  //     String? linkedin) async {
  //   final url = "${AppUrls.updateUser}/${LocalStorage.userId}";
  //   appLog("Update profile: url -> $url");

  //   try {
  //     final Map<String, dynamic> updateData = {};

  //     if (name != null) updateData['name'] = name;
  //     if (contact != null) updateData['contact'] = contact;
  //     if (country != null) updateData['country'] = country;
  //     if (city != null) updateData['city'] = city;
  //     if (gender != null) updateData['gender'] = gender;
  //     if (age != null) updateData['age'] = age;
  //     if (facebook != null) updateData['facebook'] = facebook;
  //     if (instagram != null) updateData['instagram'] = instagram;
  //     if (twitter != null) updateData['twitter'] = twitter;
  //     if (linkedin != null) updateData['linkedin'] = linkedin;

  //     if (updateData.isEmpty) {
  //       Get.snackbar("Info", "No data to update");
  //       return;
  //     }
  //     appLog(jsonEncode(updateData));
  //     final response = await http.patch(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'authorization': LocalStorage.token,
  //       },
  //       body: jsonEncode(updateData),
  //     );
  //     final jsonbody = jsonDecode(response.body);
  //     if (response.statusCode == 200 || response.statusCode == 204) {
  //       Get.snackbar("Success", jsonbody["message"],
  //           colorText: AppColors.white);
  //     } else {
  //       Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Something went wrong: $e",
  //         colorText: AppColors.white);
  //   }
  // }

  static Future<void> updateProfile(
      File? image,
      String? name,
      String? contact,
      String? country,
      String? city,
      String? gender,
      String? age,
      String? facebook,
      String? instagram,
      String? twitter,
      String? linkedin) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> updateData = {};

      if (name != null) updateData['name'] = name;
      if (contact != null) updateData['contact'] = contact;
      if (country != null) updateData['country'] = country;
      if (city != null) updateData['city'] = city;
      if (gender != null) updateData['gender'] = gender;
      if (age != null) updateData['age'] = age;
      if (facebook != null) updateData['facebook'] = facebook;
      if (instagram != null) updateData['instagram'] = instagram;
      if (twitter != null) updateData['twitter'] = twitter;
      if (linkedin != null) updateData['linkedin'] = linkedin;
      appLog("updateData: $updateData");
      if (updateData.isEmpty && image == null) {
        Get.snackbar("Info", "No data to update");
        return;
      }
      final formDataMap = <String, dynamic>{};
      if (image != null) {
        String fileName = basename(image.path);
        formDataMap['file'] = await MultipartFile.fromFile(
          image.path,
          filename: fileName,
          contentType: MediaType('image', 'png'),
        );
      }
      if (updateData.isNotEmpty) {
        formDataMap['data'] = jsonEncode(updateData);
      }
      final formData = FormData.fromMap(formDataMap);
      final url = "${AppUrls.updateUser}/${LocalStorage.userId}";
      appLog("formDataMap: $formDataMap");
      final response = await dio.patch(
        url,
        data: formData,
        options: Options(
          headers: {
            'authorization': LocalStorage.token,
            // 'Content-Type': 'multipart/form-data',
          },
        ),
      );

      final jsonbody = response.data;
      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar("Success", jsonbody["message"],
            colorText: AppColors.white);
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
      }
    } catch (e) {
      // Get.snackbar("Error", "Upload failed: $e");
      appLog("Error in update profile in patch: $e");
    }
  }

  static Future<void> MultipartRequest1({
    required String url,
    String? imagePath,
    Map<String, dynamic>? body,
  }) async {
    try {
      appLog("sending request for image: $imagePath");
      appLog(body);
      var request = http.MultipartRequest('PATCH', Uri.parse(url));
      if (body != null) {
        request.fields['data'] = jsonEncode(body);
        body.forEach((key, value) {
          request.fields[key] = value;
        });
      }

      if (imagePath != null && imagePath.isNotEmpty) {
        var mimeType = lookupMimeType(imagePath);
        var img = await http.MultipartFile.fromPath('file', imagePath,
            contentType: MediaType.parse(mimeType!));
        request.files.add(img);
      }
      final token = LocalStorage.token;
      request.headers["Authorization"] = token;

      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);
      appLog("sending request successful: ${response.body}");
      appLog(response.statusCode);
      final resp = jsonDecode(response.body);
      Get.snackbar("Success: ${resp['success']}", resp['message'],
          colorText: AppColors.white);

      return;
    } on SocketException {
      // Get.toNamed(AppRoutes.noInternetConnection);
      return;
    } on FormatException {
      return;
    } on TimeoutException {
      return;
    } catch (e) {
      appLog("request failed: $e");
      return;
    }
  }

  static Future<void> formDataRequest(
      {required Map<String, dynamic>? body,
      required String image,
      required String url}) async {
    final dio = Dio();
    final formData = FormData.fromMap({
      // "file": await MultipartFile.fromFile(
      //   image,
      // ),
      "data": jsonEncode(body),
    });
    final token = LocalStorage.token;
    try {
      final response = await dio.patch(url,
          data: formData,
          options: Options(headers: {
            "authorization": token,
            "Content-Type": "multipart/form-data"
          }));
      appLog("response from patch formData: $response");
    } catch (e) {
      appLog("Error from patch formData: $e");
    }
  }
}
