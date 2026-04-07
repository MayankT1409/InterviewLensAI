import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  // Singleton Pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    // 1. Initialize Timezones for scheduled notifications
    tz.initializeTimeZones();

    // 2. Request FCM and Local Notification permissions natively
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 3. Initialize Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          debugPrint('Notification clicked with payload: ${response.payload}');
          navigatorKey.currentState?.pushNamed('/notifications');
        }
      },
    );

    // 4. Handle FCM messages while app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM Foreground: ${message.messageId}');
      if (message.notification != null) {
        showImmediateNotification(
          id: message.hashCode,
          title: message.notification!.title,
          body: message.notification!.body,
          payload: 'fcm_foreground',
        );
      }
    });

    // 5. Handle when clicking on FCM opens the app from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      navigatorKey.currentState?.pushNamed('/notifications');
    });
  }

  // Common notification details configuration
  NotificationDetails _getNotificationDetails() {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'interview_lens_channel', // id
      'Interview Lens Notifications', // name
      channelDescription: 'Main channel for app notifications.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    return const NotificationDetails(android: androidPlatformChannelSpecifics);
  }

  /// Trigger an immediate local OS notification
  Future<void> showImmediateNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
  }) async {
    await _localNotificationsPlugin.show(
      id: id,
      title: title ?? 'New Alert',
      body: body,
      notificationDetails: _getNotificationDetails(),
      payload: payload ?? 'immediate_notification',
    );
  }

  /// Trigger a scheduled local OS notification (e.g. 5 seconds from now)
  Future<void> scheduleNotification({
    required int id,
    String? title,
    String? body,
    required Duration delay,
  }) async {
    await _localNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.now(tz.local).add(delay),
      notificationDetails: _getNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'scheduled_notification',
    );
  }
}
