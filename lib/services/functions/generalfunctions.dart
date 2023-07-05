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
      print('Karibu');
      // final Map<Permission, PermissionStatus> permissionStatus =
      //     await [Permission.contacts].request();
      // return permissionStatus[Permission.contacts] ?? PermissionStatus.limited;
    } else {
      return permission;
    }
  }

  void fetchInstalledApps() async {
    List<AppInfo> appListItems =
        await InstalledApps.getInstalledApps(true, true);
    print(appListItems);
  }

  void getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);
      // await AppUsage().getAppUsage(startDate, endDate);

      for (var info in infoList) {
        print(info.appName.toString());

        print(info.usage);
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  void requestPermissions() async {
    bool success = await FlutterBackground.hasPermissions;
    if (success) {
      print('object');
      startBackgroundTask();
    } else {
      // Permissions denied
    }
  }

  void startBackgroundTask() async {
    try {
      bool success = await FlutterBackground.enableBackgroundExecution();
      if (success) {
        // Background execution started

        Timer(Duration(seconds: 3), () {
          print('app is runing now');
        });
      } else {
        // Failed to start background execution
      }
    } on PlatformException catch (e) {
      // Handle platform exceptions
      print('error riported');
      print(e);
    }
  }

  Future<void> startBackgroundExecution() async {
    //  await FlutterBackground.enableBackgroundExecution();

    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "flutter_background example app",
      notificationText:
          "Background notification for keeping the example app running in the background",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
          name: 'background_icon',
          defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    bool success =
        await FlutterBackground.initialize(androidConfig: androidConfig);
  }

  // Back ground run functions

  Future<void> initPlatformState() async {
    // if (!mounted) return;

    FlutterBackground.initialize(
      androidConfig: FlutterBackgroundAndroidConfig(
        notificationTitle: 'Background App',
        notificationText: 'Running in the background...',
        notificationImportance: AndroidNotificationImportance.Default,
      ),
    );

    // FlutterBackground.disableWakeLock()
    FlutterBackground.disableBackgroundExecution();
    // FlutterBackground.scheduleRepeatingTask(
    //   taskId: 'my_task',
    //   taskName: 'Background Task',
    //   delay: 5000, // Delay in milliseconds before the task is executed
    //   periodic: true, // Set to true for a recurring task
    //   callback: backgroundTask,
    // );

    // setState(() {
    //   _backgroundStatus = 'Running';
    // });
  }

  void backgroundTask() {
    print('Background Task executed at ${DateTime.now()}');
    // Add your background task logic here
  }
}
