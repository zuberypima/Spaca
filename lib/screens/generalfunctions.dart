import 'package:android_intent_plus/android_intent.dart';
import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background/flutter_background.dart';

// import 'package:android_intent/android_intent.dar
import 'dart:async';

class ContorFunctions {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  _getAcces() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission.isGranted) {
      // print('Karibu');
      // final Map<Permission, PermissionStatus> permissionStatus =
      //     await [Permission.contacts].request();
      // return permissionStatus[Permission.contacts] ?? PermissionStatus.limited;
    } else {
      return permission;
    }
  }

  void fetchInstalledApps() async {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(hours: 1));
    List<AppInfo> appListItems =
        await InstalledApps.getInstalledApps(true, true);
    // List<AppUsageInfo> usageList =
    //       await AppUsage().getAppUsage(startDate, endDate);
    // checkUsageApps(appListItems[].name.toString());
    print(appListItems[10].name.toString());
    // print(usageList[10]);

    print(appListItems[10].name.toString());
  }

  void checkUsageApps(
    String appName,
  ) {
    print(appName);
  }

  void testMyfunction() {
    print('This app is runing much please cancel');
  }

  void getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);

      for (var info in infoList) {
        checkMaxmumUsage(info.usage.inSeconds, info.appName.toString());
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  checkMaxmumUsage(int usageTime, String appused) {
    int setedTime = 200;
    if (usageTime > setedTime) {
      print(appused);
      print(usageTime);
      print('Notifications is needed here boss');
    }
  }
}
