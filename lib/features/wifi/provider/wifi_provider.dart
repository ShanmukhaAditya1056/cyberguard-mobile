import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/alert_model.dart';
import '../../../data/models/wifi_result.dart';
import '../../../data/repositories/alert_repository.dart';
import '../../../data/repositories/wifi_repository.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/notification_service.dart';
import '../../../shared/providers/app_provider.dart';

class WifiState {
  final bool isLoading;
  final WifiResult? result;
  final String? error;
  final List<WifiResult> history;

  WifiState({
    required this.isLoading,
    this.result,
    this.error,
    required this.history,
  });

  WifiState copyWith({
    bool? isLoading,
    WifiResult? result,
    String? error,
    List<WifiResult>? history,
  }) {
    return WifiState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error,
      history: history ?? this.history,
    );
  }
}

class WifiNotifier extends StateNotifier<WifiState> {
  WifiNotifier(this._repository, this._alerts, this._storage, this._notificationService)
      : super(WifiState(isLoading: false, history: const [])) {
    Future.microtask(_loadHistory);
  }

  final WifiRepository _repository;
  final AlertRepository _alerts;
  final LocalStorageService _storage;
  final NotificationService _notificationService;

  Future<void> scan() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.scan();
      final history = await _repository.history();
      state = WifiState(isLoading: false, result: result, history: history);
      if (result.score < 40) {
        final alert = AlertModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'WARNING',
          title: 'Unsafe Wi-Fi detected',
          description: 'Network ${result.ssid} scored ${result.score}. Avoid sensitive activity.',
          module: 'WiFi',
          timestamp: DateTime.now(),
          isRead: false,
        );
        await _alerts.addAlert(alert);
        if (_storage.getSettings().realTimeAlerts) {
          await _notificationService.showWarningAlert(alert.title, alert.description);
        }
      }
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: 'Unable to read Wi-Fi details. Check location permissions.',
      );
    }
  }

  Future<void> _loadHistory() async {
    final history = await _repository.history();
    state = state.copyWith(history: history);
  }
}

final wifiScanProvider = StateNotifierProvider<WifiNotifier, WifiState>(
  (ref) => WifiNotifier(
    ref.read(wifiRepositoryProvider),
    ref.read(alertRepositoryProvider),
    ref.read(localStorageProvider),
    ref.read(notificationServiceProvider),
  ),
);
