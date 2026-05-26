import 'dart:math';

class ScoreCalculator {
  static int unifiedScore({
    required double phishingScore,
    required double malwareScore,
    required double breachScore,
    required double wifiScore,
    required bool breachActive,
  }) {
    final baseScore = (phishingScore * 0.30) +
        (malwareScore * 0.35) +
        (breachScore * 0.25) +
        (wifiScore * 0.10);
    var score = baseScore.round();
    if (breachActive) {
      score = min(score, 45);
    }
    return score;
  }
}
