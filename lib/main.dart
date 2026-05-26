import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'data/models/alert_model.dart';
import 'data/models/breach_result.dart';
import 'data/models/malware_result.dart';
import 'data/models/scan_result.dart';
import 'data/models/wifi_result.dart';
import 'data/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive
    ..registerAdapter(ScanResultAdapter())
    ..registerAdapter(ShapReasonAdapter())
    ..registerAdapter(ScoreEntryAdapter())
    ..registerAdapter(AlertModelAdapter())
    ..registerAdapter(SettingsModelAdapter())
    ..registerAdapter(BreachResultAdapter())
    ..registerAdapter(BreachItemAdapter())
    ..registerAdapter(BreachLogAdapter())
    ..registerAdapter(MalwareResultAdapter())
    ..registerAdapter(MalwareAppAdapter())
    ..registerAdapter(WifiResultAdapter())
    ..registerAdapter(WifiCheckAdapter());

  await Hive.openBox<ScanResult>('scan_results');
  await Hive.openBox<AlertModel>('alerts');
  await Hive.openBox<BreachLog>('breach_logs');
  await Hive.openBox<WifiResult>('wifi_scans');
  await Hive.openBox<SettingsModel>('settings');
  await Hive.openBox<ScoreEntry>('score_history');
  await Hive.openBox<bool>('onboarding_complete');

  // Initialize notifications — wrapped in try-catch for safety
  try {
    final notificationService = NotificationService();
    await notificationService.initialize();
    await notificationService.requestPermission();
  } catch (e) {
    debugPrint('NotificationService init failed: $e');
  }

  runApp(const ProviderScope(child: CyberGuardApp()));
}
