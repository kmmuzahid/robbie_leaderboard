import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';

class ApiDeleteService {
  static Future<String> deleteUser() async {
    final url = "${AppUrls.deleteUser}/${LocalStorage.userId}";
    final response = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'authorization': LocalStorage.token
    });
    final jsonbody = jsonDecode(response.body);
    return jsonbody["message"];
  }
}
