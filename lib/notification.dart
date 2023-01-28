import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/material.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void NotificationServices() async {
  AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings("@mipmap/ic_launcher");

  DarwinInitializationSettings iosSetting = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true);

  InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings, iOS: iosSetting);
  bool? initialized =
      await notificationsPlugin.initialize(initializationSettings);
}
