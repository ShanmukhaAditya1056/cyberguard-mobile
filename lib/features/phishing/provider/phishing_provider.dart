import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/alert_model.dart';
import '../../../data/models/scan_result.dart';
import '../../../data/repositories/alert_repository.dart';
import '../../../data/repositories/phishing_repository.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/notification_service.dart';
import '../../../shared/providers/app_provider.dart';

class PhishingState {
  final bool isLoading;
  final ScanResult? result;
  final String? error;

  const PhishingState({required this.isLoading, this.result, this.error});

  PhishingState copyWith({bool? isLoading, ScanResult? result, String? error}) {
    return PhishingState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error,
    );
  }
}

class PhishingNotifier extends StateNotifier<PhishingState> {
  PhishingNotifier(this._repository, this._alerts, this._storage, this._notificationService)
      : super(const PhishingState(isLoading: false));

  final PhishingRepository _repository;
  final AlertRepository _alerts;
  final LocalStorageService _storage;
  final NotificationService _notificationService;

  Future<void> scan(String input) async {
    if (input.trim().isEmpty) {
      state = state.copyWith(error: 'Please enter a URL or message.');
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.scan(input);
      state = PhishingState(isLoading: false, result: result, error: null);
      if (result.verdict == 'PHISHING') {
        final alert = AlertModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: 'WARNING',
          title: 'Phishing risk detected',
          description: 'Suspicious content detected from your scan.',
          module: 'Phishing',
          timestamp: DateTime.now(),
          isRead: false,
        );
        await _alerts.addAlert(alert);
        if (_storage.getSettings().realTimeAlerts) {
          await _notificationService.showWarningAlert(alert.title, alert.description);
        }
      }
    } catch (error) {
      state = PhishingState(isLoading: false, result: null, error: 'Scan failed. Try again.');
    }
  }
}

class HistoryNotifier extends StateNotifier<List<ScanResult>> {
  HistoryNotifier(this._repository) : super(const []) {
    Future.microtask(load);
  }

  final PhishingRepository _repository;

  Future<void> load() async {
    final history = await _repository.history();
    state = history;
  }
}

final phishingScanProvider = StateNotifierProvider<PhishingNotifier, PhishingState>(
  (ref) => PhishingNotifier(
    ref.read(phishingRepositoryProvider),
    ref.read(alertRepositoryProvider),
    ref.read(localStorageProvider),
    ref.read(notificationServiceProvider),
  ),
);

final phishingHistoryProvider = StateNotifierProvider<HistoryNotifier, List<ScanResult>>(
  (ref) => HistoryNotifier(ref.read(phishingRepositoryProvider)),
);
