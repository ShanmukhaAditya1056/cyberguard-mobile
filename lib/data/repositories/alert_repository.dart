import '../models/alert_model.dart';
import '../services/local_storage_service.dart';

class AlertRepository {
  AlertRepository(this._storage);

  final LocalStorageService _storage;

  Future<List<AlertModel>> loadAlerts() async {
    return _storage.getAlerts();
  }

  Future<void> addAlert(AlertModel alert) async {
    await _storage.addAlert(alert);
  }

  Future<void> markAllRead() async {
    final alerts = await _storage.getAlerts();
    final updated = alerts.map((a) => a.copyWith(isRead: true)).toList();
    await _storage.updateAlerts(updated);
  }

  Future<void> dismissAlert(String id) async {
    final alerts = await _storage.getAlerts();
    final updated = alerts.where((a) => a.id != id).toList();
    await _storage.updateAlerts(updated);
  }
}
