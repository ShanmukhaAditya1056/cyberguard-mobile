import 'package:hive/hive.dart';

part 'alert_model.g.dart';

@HiveType(typeId: 3)
class AlertModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String module;
  @HiveField(5)
  final DateTime timestamp;
  @HiveField(6)
  final bool isRead;

  AlertModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.module,
    required this.timestamp,
    required this.isRead,
  });

  AlertModel copyWith({bool? isRead}) => AlertModel(
        id: id,
        type: type,
        title: title,
        description: description,
        module: module,
        timestamp: timestamp,
        isRead: isRead ?? this.isRead,
      );
}

@HiveType(typeId: 11)
class SettingsModel {
  @HiveField(0)
  final bool realTimeAlerts;
  @HiveField(1)
  final bool clipboardScanner;
  @HiveField(2)
  final String autoScanFrequency;
  @HiveField(3)
  final bool wifiAutoScan;

  SettingsModel({
    required this.realTimeAlerts,
    required this.clipboardScanner,
    required this.autoScanFrequency,
    required this.wifiAutoScan,
  });

  SettingsModel copyWith({
    bool? realTimeAlerts,
    bool? clipboardScanner,
    String? autoScanFrequency,
    bool? wifiAutoScan,
  }) {
    return SettingsModel(
      realTimeAlerts: realTimeAlerts ?? this.realTimeAlerts,
      clipboardScanner: clipboardScanner ?? this.clipboardScanner,
      autoScanFrequency: autoScanFrequency ?? this.autoScanFrequency,
      wifiAutoScan: wifiAutoScan ?? this.wifiAutoScan,
    );
  }
}
