import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/alert_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../shared/providers/app_provider.dart';

class SettingsState {
  final bool realTimeAlerts;
  final bool clipboardScanner;
  final String autoScanFrequency;
  final bool wifiAutoScan;

  SettingsState({
    required this.realTimeAlerts,
    required this.clipboardScanner,
    required this.autoScanFrequency,
    required this.wifiAutoScan,
  });

  SettingsState copyWith({
    bool? realTimeAlerts,
    bool? clipboardScanner,
    String? autoScanFrequency,
    bool? wifiAutoScan,
  }) {
    return SettingsState(
      realTimeAlerts: realTimeAlerts ?? this.realTimeAlerts,
      clipboardScanner: clipboardScanner ?? this.clipboardScanner,
      autoScanFrequency: autoScanFrequency ?? this.autoScanFrequency,
      wifiAutoScan: wifiAutoScan ?? this.wifiAutoScan,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier(this._storage)
      : super(SettingsState(
          realTimeAlerts: true,
          clipboardScanner: true,
          autoScanFrequency: 'Weekly',
          wifiAutoScan: true,
        )) {
    Future.microtask(_load);
  }

  final LocalStorageService _storage;

  Future<void> _load() async {
    final model = _storage.getSettings();
    state = SettingsState(
      realTimeAlerts: model.realTimeAlerts,
      clipboardScanner: model.clipboardScanner,
      autoScanFrequency: model.autoScanFrequency,
      wifiAutoScan: model.wifiAutoScan,
    );
  }

  Future<void> updateRealTimeAlerts(bool value) async {
    state = state.copyWith(realTimeAlerts: value);
    await _persist();
  }

  Future<void> updateClipboardScanner(bool value) async {
    state = state.copyWith(clipboardScanner: value);
    await _persist();
  }

  Future<void> updateAutoScanFrequency(String value) async {
    state = state.copyWith(autoScanFrequency: value);
    await _persist();
  }

  Future<void> updateWifiAutoScan(bool value) async {
    state = state.copyWith(wifiAutoScan: value);
    await _persist();
  }

  Future<void> _persist() async {
    await _storage.saveSettings(SettingsModel(
      realTimeAlerts: state.realTimeAlerts,
      clipboardScanner: state.clipboardScanner,
      autoScanFrequency: state.autoScanFrequency,
      wifiAutoScan: state.wifiAutoScan,
    ));
  }

  Future<void> reset() async {
    state = SettingsState(
      realTimeAlerts: true,
      clipboardScanner: true,
      autoScanFrequency: 'Weekly',
      wifiAutoScan: true,
    );
    await _persist();
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(ref.read(localStorageProvider)),
);
