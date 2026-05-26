import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class SecurityCheckRow extends StatelessWidget {
  const SecurityCheckRow({super.key, required this.label, required this.status});

  final String label;
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: AppColors.textWhite)),
        ),
        Text(status, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PASS':
        return AppColors.safeGreen;
      case 'WARNING':
        return AppColors.warningAmber;
      case 'FAIL':
        return AppColors.dangerRed;
      default:
        return AppColors.textMuted;
    }
  }
}
