import '../models/breach_result.dart';
import '../services/hibp_service.dart';
import '../services/local_storage_service.dart';

class BreachRepository {
  BreachRepository(this._hibpService, this._storage);

  final HibpService _hibpService;
  final LocalStorageService _storage;

  Future<BreachResult> check(String input) async {
    final result = await _hibpService.checkCredential(input);
    await _storage.addBreachLog(
      BreachLog(query: input, result: result, checkedAt: result.checkedAt),
    );
    return result;
  }

  Future<List<BreachLog>> history() async {
    return _storage.getBreachLogs();
  }
}
