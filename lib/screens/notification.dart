import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> notificationInitializeService() async {
    // const AndroidNotificationChannel channel = AndroidNotificationChannel(
    //   'my_foreground', // id
    //   'MY FOREGROUND SERVICE', // title
    //   description: 'This channel is used for important notifications.',
    //   importance: Importance.max,
    // );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (Platform.isIOS || Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
          android: AndroidInitializationSettings('spacaapp'),
        
        ),
       
      );
       print('doneeeeeeeeee');
    }
  }

  void showLocalNotification(String title, String body) {
    print('calld');
    const androidNotificationDetail = AndroidNotificationDetails(
        '1', // channel Id
        'general', // channel Name
         importance: Importance.high
        );
    const iosNotificatonDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificatonDetail,
      android: androidNotificationDetail,
    );
    flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }
}
