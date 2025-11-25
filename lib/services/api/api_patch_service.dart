import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
// Initialize Dio with interceptors
final _dioService = Dio()
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add headers or modify request here
        // options.headers['Accept'] = 'application/json';
        // options.headers['Content-Type'] = 'application/json';

        // Add auth token if exists
        final token = StorageService.token;
        if (token.isNotEmpty) {
          options.headers['authorization'] = '$token';
        }

        print('Sending ${options.method} request to ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response from ${response.requestOptions.uri}: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        print('Error from ${e.requestOptions.uri}: ${e.response?.statusCode} - ${e.message}');

        // Return the error response if it exists
        if (e.response != null) {
          return handler.resolve(e.response!);
        }

        // If no response from server, return a custom error response
        return handler.resolve(dio.Response(
          requestOptions: e.requestOptions,
          statusCode: e.type == DioExceptionType.connectionTimeout ? 408 : 500,
          statusMessage: e.message,
        ));
      },
    ),
  )
  ..options.connectTimeout = const Duration(seconds: 30)
  ..options.receiveTimeout = const Duration(seconds: 30);

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
      final url = "${AppUrls.updateUser}/${StorageService.userId}";
      appLog("formDataMap: $formDataMap");
      
      final response = await dio.patch(
        url,
        data: formData,
        options: Options(
          headers: {
            'authorization': StorageService.token,
            // 'Content-Type': 'multipart/form-data',
          },
        ),
      );

      final jsonbody = response.data;
      if (response.statusCode == 200 || response.statusCode == 204) {
        Get.snackbar("Success", jsonbody["message"], colorText: AppColors.white);
      } else {
        Get.snackbar("Error", jsonbody["message"], colorText: AppColors.white);
      }
    } catch (e) {
      // Get.snackbar("Error", "Upload failed: $e");
      appLog("Error in update profile in patch: $e");
    }
  }

  static Future<http.Response> sendRequest({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      appLog("sending request for image: $url");
      appLog(body);
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'authorization': StorageService.token,
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      appLog("Error in sendRequest: $e");
      return Future.error(e);
    }
  }

  static Future<dio.Response?> multipartRequestWithDio({
    required String url,
    File? image,
    Map<String, dynamic>? body,
  }) async {
    try {
     
      final file = image != null
          ? await dio.MultipartFile.fromFile(image.path,
              filename: image.path.split('/').last,
              contentType: MediaType.parse(getMimeTypeFromXFile(image) ?? ''))
          : null;

      final finalBody = <String, dynamic>{
        'data': jsonEncode(body),
        // 'data': {},
        if (file != null) 'file': file,
      };

      // Set authorization token exactly as in Postman (without "Bearer" prefix if not used)
      final token = StorageService.token;
      _dioService.options.headers['authorization'] = token;
      final formData = dio.FormData.fromMap(finalBody);
      print(url);
      print(finalBody);

      // Send PATCH request with multipart/form-data
      final response = await _dioService.patch(url, data: formData);

      print("sending request successful: ${response.data}");
      print(response.statusCode);

      Get.snackbar("Success: ${response.data['success']}", response.data['message'],
          colorText: AppColors.white);

      return response;
    } catch (e) {
      print("request failed: $e");
      return null;
    }
  }

  static Future<void> formDataRequest(
      {required Map<String, dynamic>? body, required String image, required String url}) async {
    final dio = Dio();
    final formData = FormData.fromMap({
      // "file": await MultipartFile.fromFile(
      //   image,
      // ),
      "data": jsonEncode(body),
    });
    final token = StorageService.token;
    try {
      final response = await dio.patch(url,
          data: formData,
          options:
              Options(headers: {"authorization": token, "Content-Type": "multipart/form-data"}));
      appLog("response from patch formData: $response");
    } catch (e) {
      appLog("Error from patch formData: $e");
    }
  }

  static String? getMimeTypeFromXFile(File path) {
    // Get the file extension from the file path
    String extension = path.path.split('.').last.toLowerCase();

    // Map the extension to MIME type
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      case 'txt':
        return 'text/plain';
      case 'csv':
        return 'text/csv';
      case 'doc':
      case 'docx':
        return 'application/msword';
      case 'xls':
      case 'xlsx':
        return 'application/vnd.ms-excel';
      default:
        return 'application/octet-stream'; // Default MIME type for unknown extensions
    }
  }
}
