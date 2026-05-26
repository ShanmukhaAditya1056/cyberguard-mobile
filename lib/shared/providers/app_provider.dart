import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/alert_repository.dart';
import '../../data/repositories/breach_repository.dart';
import '../../data/repositories/malware_repository.dart';
import '../../data/repositories/phishing_repository.dart';
import '../../data/repositories/wifi_repository.dart';
import '../../data/services/device_info_service.dart';
import '../../data/services/hibp_service.dart';
import '../../data/services/local_storage_service.dart';
import '../../data/services/notification_service.dart';
import '../../data/services/permission_service.dart';
import '../../data/services/tflite_service.dart';

final localStorageProvider = Provider<LocalStorageService>((ref) => LocalStorageService());
final deviceInfoProvider = Provider<DeviceInfoService>((ref) => DeviceInfoService());
final hibpServiceProvider = Provider<HibpService>((ref) => HibpService());
final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());
final permissionServiceProvider = Provider<PermissionService>((ref) => PermissionService());
final tfliteServiceProvider = Provider<TfliteService>((ref) => TfliteService());

final phishingRepositoryProvider = Provider<PhishingRepository>(
  (ref) => PhishingRepository(ref.read(localStorageProvider)),
);
final malwareRepositoryProvider = Provider<MalwareRepository>(
  (ref) => MalwareRepository(ref.read(deviceInfoProvider)),
);
final breachRepositoryProvider = Provider<BreachRepository>(
  (ref) => BreachRepository(ref.read(hibpServiceProvider), ref.read(localStorageProvider)),
);
final wifiRepositoryProvider = Provider<WifiRepository>(
  (ref) => WifiRepository(ref.read(deviceInfoProvider), ref.read(localStorageProvider)),
);
final alertRepositoryProvider = Provider<AlertRepository>(
  (ref) => AlertRepository(ref.read(localStorageProvider)),
);
