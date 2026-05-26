import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/alert_model.dart';
import '../../../shared/widgets/cyber_card.dart';

class RecentAlertsWidget extends StatelessWidget {
  const RecentAlertsWidget({super.key, required this.alerts});

  final List<AlertModel> alerts;

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const CyberCard(
        child: Text('No recent alerts', style: TextStyle(color: AppColors.textMuted)),
      );
    }
    return Column(
      children: alerts
          .map(
            (alert) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CyberCard(
                leftBorderColor: _typeColor(alert.type),
                child: Row(
                  children: [
                    Icon(_typeIcon(alert.type), color: _typeColor(alert.type)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert.title,
                            style: const TextStyle(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(alert.description,
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(_timeAgo(alert.timestamp), style: const TextStyle(color: AppColors.textDim)),
                  ],
                ),
              ),
            ),
          )
          .toList(),
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
