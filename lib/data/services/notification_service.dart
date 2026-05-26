import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  factory NotificationService({FlutterLocalNotificationsPlugin? plugin}) {
    _instance._plugin = plugin ?? _instance._plugin;
    return _instance;
  }

  NotificationService._internal();

  static final NotificationService _instance = NotificationService._internal();

  FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'cyberguard_alerts';
  static const _channelName = 'CyberGuard Alerts';

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Critical and safety alerts from CyberGuard AI',
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showCriticalAlert(String title, String body) async {
    await _showAlert(title, body, Colors.red);
  }

  Future<void> showWarningAlert(String title, String body) async {
    await _showAlert(title, body, Colors.orange);
  }

  Future<void> showSafeAlert(String title, String body) async {
    await _showAlert(title, body, Colors.green);
  }

  Future<void> schedulePeriodicScan() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await _plugin.periodicallyShow(
      1001,
      'CyberGuard AI',
      'Daily security scan completed.',
      RepeatInterval.daily,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> _showAlert(String title, String body, Color color) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        importance: Importance.high,
        priority: Priority.high,
        color: color,
      ),
    );
    await _plugin.show(DateTime.now().millisecondsSinceEpoch ~/ 1000, title, body, details);
  }
}
