import 'package:hive/hive.dart';

part 'scan_result.g.dart';

@HiveType(typeId: 0)
class ScanResult {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String input;
  @HiveField(2)
  final String verdict;
  @HiveField(3)
  final double confidence;
  @HiveField(4)
  final String explanation;
  @HiveField(5)
  final DateTime timestamp;
  @HiveField(6)
  final List<ShapReason> reasons;

  ScanResult({
    required this.id,
    required this.input,
    required this.verdict,
    required this.confidence,
    required this.explanation,
    required this.timestamp,
    required this.reasons,
  });
}

@HiveType(typeId: 1)
class ShapReason {
  @HiveField(0)
  final String feature;
  @HiveField(1)
  final double contribution;

  ShapReason({required this.feature, required this.contribution});
}

@HiveType(typeId: 2)
class ScoreEntry {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final int score;
  @HiveField(2)
  final String label;

  ScoreEntry({required this.date, required this.score, required this.label});
}
