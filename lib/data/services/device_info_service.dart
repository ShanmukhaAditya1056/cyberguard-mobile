import 'dart:io';

import 'package:flutter/services.dart';

class DeviceAppInfo {
  final String name;
  final String packageName;
  final List<String> permissions;
  final DateTime installedAt;
  final DateTime updatedAt;
  final bool isSystem;

  DeviceAppInfo({
    required this.name,
    required this.packageName,
    required this.permissions,
    required this.installedAt,
    required this.updatedAt,
    required this.isSystem,
  });

  factory DeviceAppInfo.fromMap(Map<dynamic, dynamic> map) {
    final permissions = (map['permissions'] as List? ?? []).map((p) => p.toString()).toList();
    return DeviceAppInfo(
      name: map['name']?.toString() ?? 'Unknown',
      packageName: map['packageName']?.toString() ?? '',
      permissions: permissions,
      installedAt: DateTime.fromMillisecondsSinceEpoch((map['firstInstallTime'] as int?) ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch((map['lastUpdateTime'] as int?) ?? 0),
      isSystem: map['isSystem'] == true,
    );
  }
}

class WifiDeviceInfo {
  final bool isWifi;
  final String? ssid;
  final String? bssid;
  final int? rssi;
  final int? frequency;
  final int? linkSpeed;
  final String security;

  WifiDeviceInfo({
    required this.isWifi,
    required this.ssid,
    required this.bssid,
    required this.rssi,
    required this.frequency,
    required this.linkSpeed,
    required this.security,
  });

  factory WifiDeviceInfo.fromMap(Map<dynamic, dynamic> map) {
    return WifiDeviceInfo(
      isWifi: map['isWifi'] == true,
      ssid: map['ssid']?.toString(),
      bssid: map['bssid']?.toString(),
      rssi: map['rssi'] as int?,
      frequency: map['frequency'] as int?,
      linkSpeed: map['linkSpeed'] as int?,
      security: map['security']?.toString() ?? 'UNKNOWN',
    );
  }
}

class DeviceInfoService {
  static const MethodChannel _channel = MethodChannel('cyberguard/app_inspector');

  Future<List<DeviceAppInfo>> getInstalledApps({bool includeSystem = false}) async {
    if (!Platform.isAndroid) {
      return [];
    }
    final raw = await _channel.invokeMethod<List<dynamic>>(
      'getInstalledApps',
      {'includeSystem': includeSystem},
    );
    final list = raw ?? [];
    return list
        .whereType<Map>()
        .map((map) => DeviceAppInfo.fromMap(map))
        .toList();
  }

  Future<WifiDeviceInfo> getWifiInfo() async {
    if (!Platform.isAndroid) {
      return WifiDeviceInfo(
        isWifi: false,
        ssid: null,
        bssid: null,
        rssi: null,
        frequency: null,
        linkSpeed: null,
        security: 'UNKNOWN',
      );
    }
    final raw = await _channel.invokeMethod<Map<dynamic, dynamic>>('getWifiInfo');
    return WifiDeviceInfo.fromMap(raw ?? {});
  }
}
