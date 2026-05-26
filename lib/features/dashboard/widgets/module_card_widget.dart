import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/cyber_card.dart';

class ModuleCardWidget extends StatelessWidget {
  const ModuleCardWidget({
    super.key,
    required this.title,
    required this.status,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String status;
  final IconData icon;
  final VoidCallback onTap;

  Color get _statusColor {
    switch (status) {
      case 'SAFE':
        return AppColors.safeGreen;
      case 'WARNING':
        return AppColors.warningAmber;
      case 'CRITICAL':
        return AppColors.critical;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: CyberCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: _statusColor),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(status, style: TextStyle(color: _statusColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
