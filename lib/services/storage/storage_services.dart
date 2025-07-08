import 'package:shared_preferences/shared_preferences.dart';
import 'storage_keys.dart';

class LocalStorage {
  static String token = "";
  static String cookie = "";
  static String refreshToken = "";
  static bool isLogIn = false;
  static String userId = "";
  static String myImage = "";
  static String myName = "";
  static String myEmail = "";
  static String myPassword = "";
  static bool rememberMe = false;
  static String today = "";
  static int dayIndex = 0;
  static int totalTicket = 0;
  static String otherUserId = "";

  // Create Local Storage Instance
  static SharedPreferences? preferences;

  /// Get SharedPreferences Instance
  static Future<SharedPreferences> _getStorage() async {
    preferences ??= await SharedPreferences.getInstance();
    return preferences!;
  }

  /// Get All Data From SharedPreferences
  static Future<void> getAllPrefData() async {
    final localStorage = await _getStorage();

    token = localStorage.getString(LocalStorageKeys.token) ?? "";
    cookie = localStorage.getString(LocalStorageKeys.cookie) ?? "";
    refreshToken = localStorage.getString(LocalStorageKeys.refreshToken) ?? "";
    isLogIn = localStorage.getBool(LocalStorageKeys.isLogIn) ?? false;
    userId = localStorage.getString(LocalStorageKeys.userId) ?? "";
    myImage = localStorage.getString(LocalStorageKeys.myImage) ?? "";
    myName = localStorage.getString(LocalStorageKeys.myName) ?? "";
    myEmail = localStorage.getString(LocalStorageKeys.myEmail) ?? "";
    myPassword = localStorage.getString(LocalStorageKeys.myPassword) ?? "";
    rememberMe = localStorage.getBool(LocalStorageKeys.rememberMe) ?? false;
    today = localStorage.getString(LocalStorageKeys.today) ?? "";
    dayIndex = localStorage.getInt(LocalStorageKeys.dayIndex) ?? 0;
    totalTicket = localStorage.getInt(LocalStorageKeys.totalTicket) ?? 0;
    otherUserId = localStorage.getString(LocalStorageKeys.otherUserId) ?? "";
    //appLog(userId, source: "Local Storage");
  }

  /// Remove All Data From SharedPreferences
  static Future<void> removeAllPrefData() async {
    final localStorage = await _getStorage();
    await localStorage.clear();
    _resetLocalStorageData();
    //Get.offAllNamed(AppRoutes.signIn);
    await getAllPrefData();
  }

  // Reset LocalStorage Data
  static void _resetLocalStorageData() {
    final localStorage = preferences!;
    localStorage.setString(LocalStorageKeys.token, "");
    localStorage.setString(LocalStorageKeys.cookie, "");
    localStorage.setString(LocalStorageKeys.refreshToken, "");
    localStorage.setString(LocalStorageKeys.userId, "");
    localStorage.setString(LocalStorageKeys.myImage, "");
    localStorage.setString(LocalStorageKeys.myName, "");
    localStorage.setBool(LocalStorageKeys.isLogIn, false);
    localStorage.setString(LocalStorageKeys.otherUserId, "");
  }

  // Save Data To SharedPreferences
  static Future<void> setString(String key, String value) async {
    final localStorage = await _getStorage();
    await localStorage.setString(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    final localStorage = await _getStorage();
    await localStorage.setBool(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    final localStorage = await _getStorage();
    await localStorage.setInt(key, value);
  }
}
