import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/scan_result.dart';
import '../../../shared/widgets/cyber_card.dart';

class ScanHistoryWidget extends StatelessWidget {
  const ScanHistoryWidget({super.key, required this.history});

  final List<ScanResult> history;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const CyberCard(
        child: Text('No recent scans', style: TextStyle(color: AppColors.textMuted)),
      );
    }
    return Column(
      children: history
          .map(
            (scan) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CyberCard(
                child: Row(
                  children: [
                    Icon(
                      scan.verdict == 'PHISHING' ? Icons.warning : Icons.check_circle,
                      color: scan.verdict == 'PHISHING' ? AppColors.dangerRed : AppColors.safeGreen,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _truncate(scan.input),
                            style: const TextStyle(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            scan.verdict,
                            style: TextStyle(
                              color: scan.verdict == 'PHISHING'
                                  ? AppColors.dangerRed
                                  : AppColors.safeGreen,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      DateFormat('hh:mm a').format(scan.timestamp),
                      style: const TextStyle(color: AppColors.textDim, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  String _truncate(String text) {
    if (text.length <= 36) return text;
    return '${text.substring(0, 33)}...';
  }
}
