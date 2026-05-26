import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/score_calculator.dart';
import '../../../data/models/alert_model.dart';
import '../../../data/models/malware_result.dart';
import '../../../data/models/scan_result.dart';
import '../../../data/repositories/malware_repository.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../shared/providers/app_provider.dart';

class ScoreState {
  final int score;
  final String label;
  final DateTime? lastScan;

  ScoreState({required this.score, required this.label, required this.lastScan});
}

class ModuleStatus {
  final String title;
  final String statusLabel;
  final int score;
  final String route;

  ModuleStatus({
    required this.title,
    required this.statusLabel,
    required this.score,
    required this.route,
  });
}

class DashboardStats {
  final List<ModuleStatus> modules;
  final List<AlertModel> recentAlerts;

  DashboardStats({required this.modules, required this.recentAlerts});
}

class ScoreNotifier extends StateNotifier<ScoreState> {
  ScoreNotifier(this._storage, this._malwareRepository)
      : super(ScoreState(score: 0, label: 'SAFE', lastScan: null));

  final LocalStorageService _storage;
  final MalwareRepository _malwareRepository;

  Future<void> initialize() async {
    await refresh();
  }

  Future<void> refresh() async {
    final phishing = await _latestPhishing();
    final breach = await _latestBreach();
    final wifi = await _latestWifi();
    final malwareScore = await _calculateMalwareScore();

    final score = ScoreCalculator.unifiedScore(
      phishingScore: phishing.$1,
      malwareScore: malwareScore,
      breachScore: breach.$1,
      wifiScore: wifi.$1,
      breachActive: breach.$2,
    );
    final label = score >= 70 ? 'SAFE' : (score >= 40 ? 'WARNING' : 'CRITICAL');
    final lastScan = [phishing.$3, breach.$3, wifi.$3]
      ..removeWhere((d) => d == null);
    final lastScanAt = lastScan.isEmpty
        ? null
        : lastScan.cast<DateTime>().reduce((a, b) => a.isAfter(b) ? a : b);
    state = ScoreState(score: score, label: label, lastScan: lastScanAt);
    await _storage.addScoreEntry(ScoreEntry(date: DateTime.now(), score: score, label: label));
  }

  Future<double> _calculateMalwareScore() async {
    List<MalwareApp> apps;
    try {
      apps = await _malwareRepository.getApps();
    } catch (_) {
      return 70;
    }
    if (apps.isEmpty) {
      return 80;
    }
    final maxRisk = apps.map((a) => a.riskScore).fold<int>(0, (p, n) => n > p ? n : p);
    return (100 - maxRisk).clamp(10, 100).toDouble();
  }

  Future<(double, bool, DateTime?)> _latestBreach() async {
    final logs = await _storage.getBreachLogs();
    if (logs.isEmpty) {
      return (90.0, false, null);
    }
    final latest = logs.first;
    return (latest.result.found ? 25.0 : 90.0, latest.result.found, latest.checkedAt);
  }

  Future<(double, bool, DateTime?)> _latestPhishing() async {
    final scans = await _storage.getScanHistory(limit: 1);
    if (scans.isEmpty) {
      return (85.0, false, null);
    }
    final latest = scans.first;
    return (latest.verdict == 'PHISHING' ? 20.0 : 90.0, false, latest.timestamp);
  }

  Future<(double, bool, DateTime?)> _latestWifi() async {
    final scans = await _storage.getWifiHistory(limit: 1);
    if (scans.isEmpty) {
      return (70.0, false, null);
    }
    final latest = scans.first;
    return (latest.score.toDouble(), latest.score < 30, latest.scannedAt);
  }
}

final unifiedScoreProvider = StateNotifierProvider<ScoreNotifier, ScoreState>(
  (ref) {
    final notifier = ScoreNotifier(ref.read(localStorageProvider), ref.read(malwareRepositoryProvider));
    Future.microtask(notifier.initialize);
    return notifier;
  },
);

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final storage = ref.read(localStorageProvider);
  final alerts = await ref.read(alertRepositoryProvider).loadAlerts();
  final phishingScore = (await storage.getScanHistory(limit: 1)).firstOrNull?.verdict == 'PHISHING'
      ? 20
      : 90;
  final breachFound = (await storage.getBreachLogs()).firstOrNull?.result.found ?? false;
  final wifiScore = (await storage.getWifiHistory(limit: 1)).firstOrNull?.score ?? 70;
  List<MalwareApp> apps;
  try {
    apps = await ref.read(malwareRepositoryProvider).getApps();
  } catch (_) {
    apps = [];
  }
  final malwareScore = apps.map((a) => a.riskScore).fold<int>(0, (p, n) => n > p ? n : p);
  final modules = [
    ModuleStatus(
      title: 'Phishing Scanner',
      statusLabel: phishingScore < 40 ? 'CRITICAL' : (phishingScore < 70 ? 'WARNING' : 'SAFE'),
      score: phishingScore,
      route: '/phishing',
    ),
    ModuleStatus(
      title: 'Malware Scanner',
      statusLabel: malwareScore > 80 ? 'CRITICAL' : (malwareScore > 60 ? 'WARNING' : 'SAFE'),
      score: (100 - malwareScore).clamp(0, 100),
      route: '/malware',
    ),
    ModuleStatus(
      title: 'Breach Monitor',
      statusLabel: breachFound ? 'WARNING' : 'SAFE',
      score: breachFound ? 30 : 90,
      route: '/breach',
    ),
    ModuleStatus(
      title: 'Wi-Fi Scanner',
      statusLabel: wifiScore < 40 ? 'CRITICAL' : (wifiScore < 70 ? 'WARNING' : 'SAFE'),
      score: wifiScore,
      route: '/wifi',
    ),
  ];

  return DashboardStats(modules: modules, recentAlerts: alerts.take(3).toList());
});

extension _ListFirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
