import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class TrustScoreGauge extends StatelessWidget {
  const TrustScoreGauge({super.key, required this.score, required this.label});

  final int score;
  final String label;

  Color get _color {
    if (score >= 70) return AppColors.safeGreen;
    if (score >= 40) return AppColors.warningAmber;
    return AppColors.dangerRed;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$score', style: TextStyle(color: _color, fontSize: 36, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: _color, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: score / 100,
          minHeight: 8,
          backgroundColor: AppColors.border,
          valueColor: AlwaysStoppedAnimation(_color),
        ),
      ],
    );
  }
}
