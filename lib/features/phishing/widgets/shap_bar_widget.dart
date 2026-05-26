import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/scan_result.dart';

class ShapBarWidget extends StatelessWidget {
  const ShapBarWidget({super.key, required this.reason});

  final ShapReason reason;

  Color get _color {
    if (reason.contribution >= 0.4) return AppColors.dangerRed;
    if (reason.contribution >= 0.25) return AppColors.warningAmber;
    return AppColors.accentBlue;
  }

  @override
  Widget build(BuildContext context) {
    final percent = (reason.contribution * 100).clamp(0, 100).toDouble();
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            reason.feature,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ),
        Expanded(
          flex: 5,
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: 6,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation(_color),
          ),
        ),
        const SizedBox(width: 8),
        Text('${percent.toStringAsFixed(0)}%',
            style: TextStyle(color: _color, fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
