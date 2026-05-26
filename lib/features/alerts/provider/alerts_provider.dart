import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/alert_model.dart';
import '../../../data/repositories/alert_repository.dart';
import '../../../shared/providers/app_provider.dart';

class AlertsNotifier extends StateNotifier<List<AlertModel>> {
  AlertsNotifier(this._repository) : super(const []) {
    Future.microtask(_initAndLoad);
  }

  final AlertRepository _repository;

  Future<void> _initAndLoad() async {
    final alerts = await _repository.loadAlerts();
    if (alerts.isEmpty) {
      await _seedSampleAlerts();
    }
    state = await _repository.loadAlerts();
  }

  Future<void> load() async {
    state = await _repository.loadAlerts();
  }

  Future<void> markAllRead() async {
    await _repository.markAllRead();
    state = await _repository.loadAlerts();
  }

  Future<void> dismiss(String id) async {
    await _repository.dismissAlert(id);
    state = await _repository.loadAlerts();
  }

  Future<void> _seedSampleAlerts() async {
    final now = DateTime.now();
    final samples = [
      AlertModel(
        id: '${now.millisecondsSinceEpoch}_1',
        type: 'CRITICAL',
        title: 'BatteryFast Pro — Spyware Detected',
        description:
            'Cam+mic+contacts pattern detected. Remove immediately.',
        module: 'Malware',
        timestamp: now.subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      AlertModel(
        id: '${now.millisecondsSinceEpoch}_2',
        type: 'WARNING',
        title: 'Clipboard — Phishing URL',
        description:
            'secure-hdfc.verify-now.xyz detected in clipboard.',
        module: 'Phishing',
        timestamp: now.subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
      AlertModel(
        id: '${now.millisecondsSinceEpoch}_3',
        type: 'WARNING',
        title: 'Wi-Fi: CafeWifi_Guest',
        description:
            'Outdated WPA2 encryption. Rogue AP suspect nearby.',
        module: 'WiFi',
        timestamp: now.subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      AlertModel(
        id: '${now.millisecondsSinceEpoch}_4',
        type: 'SAFE',
        title: 'Scan Complete',
        description: '42 apps scanned. 2 threats found.',
        module: 'Malware',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      AlertModel(
        id: '${now.millisecondsSinceEpoch}_5',
        type: 'INFO',
        title: 'Breach Database Updated',
        description:
            '4 new breaches added to monitoring list.',
        module: 'Breach',
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
      ),
    ];

    for (final alert in samples) {
      await _repository.addAlert(alert);
    }
  }
}

final alertsProvider = StateNotifierProvider<AlertsNotifier, List<AlertModel>>(
  (ref) => AlertsNotifier(ref.read(alertRepositoryProvider)),
);
