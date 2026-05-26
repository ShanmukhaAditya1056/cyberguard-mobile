import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/alert_model.dart';
import '../../../shared/widgets/cyber_card.dart';

class AlertCardWidget extends StatelessWidget {
  const AlertCardWidget({super.key, required this.alert});

  final AlertModel alert;

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(alert.type);
    return CyberCard(
      leftBorderColor: color,
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        collapsedIconColor: AppColors.textMuted,
        iconColor: AppColors.textMuted,
        title: Row(
          children: [
            Icon(_typeIcon(alert.type), color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(alert.title,
                  style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withAlpha((0.2 * 255).round()),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(alert.type, style: TextStyle(color: color, fontSize: 10)),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(alert.description, style: const TextStyle(color: AppColors.textMuted)),
            ),
            const SizedBox(width: 8),
            Text(_timeAgo(alert.timestamp), style: const TextStyle(color: AppColors.textDim, fontSize: 11)),
          ],
        ),
        children: [
          const SizedBox(height: 8),
          Text(
            'Module: ${alert.module}',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'CRITICAL':
        return AppColors.critical;
      case 'WARNING':
        return AppColors.warningAmber;
      case 'SAFE':
        return AppColors.safeGreen;
      default:
        return AppColors.textDim;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'CRITICAL':
        return Icons.warning;
      case 'WARNING':
        return Icons.error_outline;
      case 'SAFE':
        return Icons.check_circle;
      default:
        return Icons.info_outline;
    }
  }

  String _timeAgo(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('d MMM').format(time);
  }
}
