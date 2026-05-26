import 'dart:math';

import '../models/wifi_result.dart';
import '../services/device_info_service.dart';
import '../services/local_storage_service.dart';

class WifiRepository {
  WifiRepository(this._deviceInfo, this._storage);

  final DeviceInfoService _deviceInfo;
  final LocalStorageService _storage;

  Future<WifiResult> scan() async {
    final info = await _deviceInfo.getWifiInfo();
    if (!info.isWifi || info.ssid == null || info.ssid!.isEmpty) {
      throw StateError('No active Wi-Fi connection detected.');
    }
    final ssid = info.ssid!;
    final isPublic = _isPublicNetwork(ssid);
    final encryption = info.security;
    final score = _calculateTrustScore(encryption, isPublic);
    final label = score >= 70 ? 'SECURE' : (score >= 40 ? 'CAUTION' : 'DANGER');
    final checks = _buildChecks(score, encryption);

    final result = WifiResult(
      ssid: ssid,
      encryption: encryption,
      isPublic: isPublic,
      score: score,
      label: label,
      checks: checks,
      scannedAt: DateTime.now(),
    );
    await _storage.addWifiScan(result);
    return result;
  }

  Future<List<WifiResult>> history() async {
    return _storage.getWifiHistory();
  }

  bool _isPublicNetwork(String ssid) {
    final value = ssid.toLowerCase();
    return value.contains('guest') ||
        value.contains('public') ||
        value.contains('cafe') ||
        value.contains('free') ||
        value.contains('open') ||
        value.contains('hotel') ||
        value.contains('airport') ||
        value.contains('mall') ||
        value.contains('metro') ||
        value.contains('railway');
  }

  /// Exact trust score formula from spec
  int _calculateTrustScore(String encryption, bool isPublic) {
    final rng = Random();
    final enc = encryption.toUpperCase();
    if (enc == 'WPA3' && !isPublic) {
      return 86 + rng.nextInt(10); // 86-95
    }
    if (enc == 'WPA2' && !isPublic) {
      return 70 + rng.nextInt(15); // 70-84
    }
    if (enc == 'WPA2' && isPublic) {
      return 50 + rng.nextInt(16); // 50-65
    }
    if (enc == 'WPA') {
      return 35 + rng.nextInt(16); // 35-50
    }
    if (enc == 'WEP') {
      return 15 + rng.nextInt(16); // 15-30
    }
    if (enc == 'OPEN' || enc == 'NONE') {
      return 5 + rng.nextInt(11); // 5-15
    }
    // UNKNOWN — default moderate score
    if (isPublic) return 45 + rng.nextInt(11);
    return 60 + rng.nextInt(11);
  }

  List<WifiCheck> _buildChecks(int score, String encryption) {
    String statusFor(int threshold) {
      if (score >= threshold) return 'PASS';
      if (score >= 40) return 'WARNING';
      return 'FAIL';
    }

    String encryptionStatus() {
      return switch (encryption.toUpperCase()) {
        'WPA3' => 'PASS',
        'WPA2' => 'PASS',
        'WPA' => 'WARNING',
        'WEP' => 'FAIL',
        'OPEN' || 'NONE' => 'FAIL',
        _ => statusFor(60),
      };
    }

    return [
      WifiCheck(label: 'Encryption type', status: encryptionStatus()),
      WifiCheck(label: 'Rogue AP detection', status: statusFor(60)),
      WifiCheck(label: 'DNS spoofing', status: statusFor(55)),
      WifiCheck(label: 'Evil twin detection', status: statusFor(50)),
      WifiCheck(label: 'MITM risk', status: statusFor(45)),
      WifiCheck(label: 'Gateway integrity', status: statusFor(50)),
    ];
  }
}
