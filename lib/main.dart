import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:the_leaderboard/screens/notification_screen/controller/notification_controller.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/revenue_cat_util.dart' as revenue_cat;
import 'main_app_entry.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    // statusBarIconBrightness:
    //     Brightness.light, // dark icons for light background
    // statusBarBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // await GetStorage.init();

  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => const MainApp(), // Wrap your app
  //   ),
  // );
  Get.put(NotificationController());
  HttpOverrides.global = MyHttpOverrides();
  await LocalStorage.getAllPrefData();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await revenue_cat.initialize(
    "App Store API Key",
    "goog_gsyjGglgxeOOHLKmCuTaOliiTFa",
    debugLogEnabled: true,
    loadDataAfterLaunch: true,
  );
  await Purchases.setLogLevel(LogLevel.debug);
  // await Purchases.configure(
  //   PurchasesConfiguration("goog_gsyjGglgxeOOHLKmCuTaOliiTFa")
  //     ..appUserID = LocalStorage.userId, // optional
  // );
  // LocalStorage.getAllPrefData();
  runApp(const MainApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
