import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../core/theme/app_colors.dart';

class ScoreRingWidget extends StatelessWidget {
  const ScoreRingWidget({super.key, required this.score, required this.label});

  final int score;
  final String label;

  Color get _color {
    if (score >= 70) return AppColors.safeGreen;
    if (score >= 40) return AppColors.warningAmber;
    return AppColors.dangerRed;
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 80,
      lineWidth: 10,
      percent: score / 100,
      animation: true,
      animationDuration: 1200,
      progressColor: _color,
      backgroundColor: AppColors.border,
      center: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$score',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textWhite,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
