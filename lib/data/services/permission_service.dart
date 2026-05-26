import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<Map<Permission, PermissionStatus>> requestAll() async {
    if (!Platform.isAndroid) {
      return {};
    }
    final permissions = <Permission>[
      Permission.notification,
      Permission.locationWhenInUse,
      Permission.contacts,
      Permission.phone,
      Permission.sms,
      Permission.microphone,
      Permission.camera,
      Permission.storage,
      Permission.photos,
      Permission.videos,
      Permission.audio,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.nearbyWifiDevices,
    ];
    return permissions.request();
  }

  Future<bool> hasCorePermissions() async {
    if (!Platform.isAndroid) {
      return true;
    }
    final location = await Permission.locationWhenInUse.status;
    final notifications = await Permission.notification.status;
    return location.isGranted && notifications.isGranted;
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }
}
