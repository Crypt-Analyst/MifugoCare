import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../data/repositories/user_repository.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(settings);

    await _messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null || notification.title == null) {
        return;
      }

      _showLocalNotification(
        title: notification.title ?? 'MifugoCare',
        body: notification.body ?? '',
      );
    });

    _initialized = true;
  }

  Future<void> registerDevice(String uid) async {
    if (kIsWeb) {
      return;
    }

    final token = await _messaging.getToken();
    if (token == null) {
      return;
    }

    await UserRepository().updateFcmToken(uid: uid, token: token);
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'mifugo_notifications',
        'MifugoCare Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _localNotifications.show(0, title, body, details);
  }
}
