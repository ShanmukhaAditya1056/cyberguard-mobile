import 'package:hive/hive.dart';

part 'wifi_result.g.dart';

@HiveType(typeId: 9)
class WifiResult {
  @HiveField(0)
  final String ssid;
  @HiveField(1)
  final String encryption;
  @HiveField(2)
  final bool isPublic;
  @HiveField(3)
  final int score;
  @HiveField(4)
  final String label;
  @HiveField(5)
  final List<WifiCheck> checks;
  @HiveField(6)
  final DateTime scannedAt;

  WifiResult({
    required this.ssid,
    required this.encryption,
    required this.isPublic,
    required this.score,
    required this.label,
    required this.checks,
    required this.scannedAt,
  });
}

@HiveType(typeId: 10)
class WifiCheck {
  @HiveField(0)
  final String label;
  @HiveField(1)
  final String status;

  WifiCheck({required this.label, required this.status});
}
