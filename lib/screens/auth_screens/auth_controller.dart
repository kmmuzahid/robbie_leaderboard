import 'package:get/get.dart';

class AuthController extends GetxController {
  final RxString accessToken = ''.obs;
  final RxString userId = ''.obs;
  final RxString userEmail = ''.obs;

  void setAccessToken(String token) {
    accessToken.value = token;
  }

  String get token {
    return accessToken.value;
  }

  void clearToken() {
    accessToken.value = '';
  }

  void setUserId(String id) {
    userId.value = id;
  }

  String get getUserId => userId.value;
  void setEmail(String email) {
    userEmail.value = email;
  }

  String get getEmail => userEmail.value;
}
