import 'package:hive/hive.dart';

part 'breach_result.g.dart';

@HiveType(typeId: 4)
class BreachResult {
  @HiveField(0)
  final bool found;
  @HiveField(1)
  final int count;
  @HiveField(2)
  final List<BreachItem> breaches;
  @HiveField(3)
  final String source;
  @HiveField(4)
  final String query;
  @HiveField(5)
  final DateTime checkedAt;

  BreachResult({
    required this.found,
    required this.count,
    required this.breaches,
    required this.source,
    required this.query,
    required this.checkedAt,
  });
}

@HiveType(typeId: 5)
class BreachItem {
  @HiveField(0)
  final String site;
  @HiveField(1)
  final String date;
  @HiveField(2)
  final String accounts;
  @HiveField(3)
  final List<String> types;

  const BreachItem({
    required this.site,
    required this.date,
    required this.accounts,
    required this.types,
  });
}

@HiveType(typeId: 6)
class BreachLog {
  @HiveField(0)
  final String query;
  @HiveField(1)
  final BreachResult result;
  @HiveField(2)
  final DateTime checkedAt;

  BreachLog({required this.query, required this.result, required this.checkedAt});
}
