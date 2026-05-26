import 'package:hive/hive.dart';

import '../models/alert_model.dart';
import '../models/breach_result.dart';
import '../models/scan_result.dart';
import '../models/wifi_result.dart';

class LocalStorageService {
  Box<ScanResult> get scanResultsBox => Hive.box<ScanResult>('scan_results');
  Box<AlertModel> get alertsBox => Hive.box<AlertModel>('alerts');
  Box<BreachLog> get breachLogsBox => Hive.box<BreachLog>('breach_logs');
  Box<WifiResult> get wifiScansBox => Hive.box<WifiResult>('wifi_scans');
  Box<SettingsModel> get settingsBox => Hive.box<SettingsModel>('settings');
  Box<ScoreEntry> get scoreHistoryBox => Hive.box<ScoreEntry>('score_history');
  Box<bool> get onboardingBox => Hive.box<bool>('onboarding_complete');

  Future<void> addScanResult(ScanResult result) async {
    await scanResultsBox.add(result);
  }

  Future<List<ScanResult>> getScanHistory({int limit = 6}) async {
    final list = scanResultsBox.values.toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list.take(limit).toList();
  }

  Future<void> addAlert(AlertModel alert) async {
    await alertsBox.add(alert);
  }

  Future<void> updateAlerts(List<AlertModel> alerts) async {
    await alertsBox.clear();
    await alertsBox.addAll(alerts);
  }

  Future<List<AlertModel>> getAlerts() async {
    final list = alertsBox.values.toList();
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  Future<void> addBreachLog(BreachLog log) async {
    await breachLogsBox.add(log);
  }

  Future<List<BreachLog>> getBreachLogs() async {
    final list = breachLogsBox.values.toList();
    list.sort((a, b) => b.checkedAt.compareTo(a.checkedAt));
    return list;
  }

  Future<void> addWifiScan(WifiResult result) async {
    await wifiScansBox.add(result);
  }

  Future<List<WifiResult>> getWifiHistory({int limit = 5}) async {
    final list = wifiScansBox.values.toList();
    list.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
    return list.take(limit).toList();
  }

  Future<void> saveSettings(SettingsModel settings) async {
    await settingsBox.put('current', settings);
  }

  SettingsModel getSettings() {
    return settingsBox.get(
          'current',
          defaultValue: SettingsModel(
            realTimeAlerts: true,
            clipboardScanner: true,
            autoScanFrequency: 'Weekly',
            wifiAutoScan: true,
          ),
        ) ??
        SettingsModel(
          realTimeAlerts: true,
          clipboardScanner: true,
          autoScanFrequency: 'Weekly',
          wifiAutoScan: true,
        );
  }

  Future<void> addScoreEntry(ScoreEntry entry) async {
    if (scoreHistoryBox.length >= 30) {
      await scoreHistoryBox.deleteAt(0);
    }
    await scoreHistoryBox.add(entry);
  }

  Future<List<ScoreEntry>> getScoreHistory() async {
    return scoreHistoryBox.values.toList();
  }

  Future<void> setOnboardingComplete(bool value) async {
    await onboardingBox.put('done', value);
  }

  bool isOnboardingComplete() {
    return onboardingBox.get('done', defaultValue: false) ?? false;
  }

  Future<void> clearAll() async {
    await scanResultsBox.clear();
    await alertsBox.clear();
    await breachLogsBox.clear();
    await wifiScansBox.clear();
    await settingsBox.clear();
    await scoreHistoryBox.clear();
  }
}
