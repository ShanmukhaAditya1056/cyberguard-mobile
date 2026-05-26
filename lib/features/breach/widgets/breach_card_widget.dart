import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/breach_result.dart';
import '../../../shared/widgets/cyber_card.dart';

class BreachCardWidget extends StatelessWidget {
  const BreachCardWidget({super.key, required this.breach});

  final BreachItem breach;

  @override
  Widget build(BuildContext context) {
    return CyberCard(
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        collapsedIconColor: AppColors.textMuted,
        iconColor: AppColors.textMuted,
        title: Text(breach.site,
            style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
        subtitle: Text('${breach.date} • ${breach.accounts}',
            style: const TextStyle(color: AppColors.textMuted)),
        children: [
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: breach.types
                .map((type) => Chip(
                      label: Text(type),
                      backgroundColor: AppColors.card,
                      labelStyle: const TextStyle(color: AppColors.textMuted),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          const Text(
            'Remediation steps',
            style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            '1. Change your password immediately.\n'
            '2. Enable two-factor authentication.\n'
            '3. Monitor bank and UPI activity.\n'
            '4. Avoid reusing old passwords.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
