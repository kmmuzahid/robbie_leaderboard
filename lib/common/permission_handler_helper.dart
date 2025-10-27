import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app_log.dart';

class PermissionHandlerHelper {
  const PermissionHandlerHelper({required this.permission});
  final Permission permission;

  Future<bool> getStatus() async {
    late bool curentStatus;
    if (permission == Permission.notification && Platform.isIOS) {
      // curentStatus = await _requestNotificationPermission();
    } else if (permission == Permission.photos && Platform.isIOS) {
      curentStatus = await _requestPhotoPermission();
    } else {
      curentStatus = (await permission.status).isGranted == true;
    }
    if (curentStatus == false) {
      AppLogger.warning(
        'Sorry! Current Permission Status is ${curentStatus}, need to take permission',
        tag: 'Screenshot',
      );
      final status = await permission.request();
      if (status.isGranted == false) {
        AppLogger.warning(
          'Sorry! Permission No ${permission.value} is ${status.name}',
          tag: 'Screenshot',
        );
        if (status.isPermanentlyDenied) {
          _dialog();
        }
        return false;
      }
    }
    return true;
  }

  Future<dynamic> _dialog() {
    return showDialog(
      context: Get.context!,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text(
              'Permission Denied',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                children: [
                  TextSpan(
                    text:
                        '❌ ${_getPermissionName(permission)} permission is permanently denied.\n\n',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: '✅ To fix this, please go to ',
                    style: TextStyle(color: Colors.green[700]),
                  ),
                  const TextSpan(
                    text: 'App Settings',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' and allow the permission manually.',
                    style: TextStyle(color: Colors.green[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              openAppSettings();
              Navigator.pop(Get.context!);
            },
            icon: const Icon(Icons.settings, color: Colors.blue),
            label: const Text(
              'Open Settings',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(Get.context!),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  String _getPermissionName(Permission permission) {
    switch (permission) {
      case Permission.location:
      case Permission.locationWhenInUse:
      case Permission.locationAlways:
        return 'Location';
      case Permission.camera:
        return 'Camera';
      case Permission.microphone:
        return 'Microphone';
      case Permission.photos:
      case Permission.photosAddOnly:
        return 'Photos';
      case Permission.storage:
        return 'Storage';
      case Permission.notification:
        return 'Notifications';
      case Permission.contacts:
        return 'Contacts';
      case Permission.sms:
        return 'SMS';
      case Permission.bluetooth:
      case Permission.bluetoothScan:
      case Permission.bluetoothAdvertise:
      case Permission.bluetoothConnect:
        return 'Bluetooth';
      case Permission.mediaLibrary:
        return 'Media Library';
      default:
        return permission.toString().split('.').last; // fallback
    }
  }

  // Future<bool> _requestNotificationPermission() async {
  //   return (await flutterLocalNotificationsPlugin
  //           .resolvePlatformSpecificImplementation<
  //               IOSFlutterLocalNotificationsPlugin>()
  //           ?.requestPermissions(
  //             alert: true,
  //             badge: true,
  //             sound: true,
  //           )) ??
  //       false;
  // }

  static const MethodChannel _photoChannel =
      MethodChannel('photoPermissionChannel');

  static Future<bool> _requestPhotoPermission() async {
    try {
      final String result =
          await _photoChannel.invokeMethod('requestPhotoPermission');
      return result == "Photo access granted";
    } on PlatformException catch (e) {
      return false;
    }
  }
}
