import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/breach_result.dart';
import '../widgets/breach_card_widget.dart';

class BreachDetailScreen extends StatelessWidget {
  const BreachDetailScreen({super.key, required this.result});

  final BreachResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breach Details'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(result.query, style: const TextStyle(color: AppColors.textWhite)),
          const SizedBox(height: 8),
          Text('Source: ${result.source}', style: const TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 16),
          if (result.breaches.isEmpty)
            const Text('No breach details available.', style: TextStyle(color: AppColors.textMuted))
          else
            ...result.breaches.map((breach) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BreachCardWidget(breach: breach),
                )),
        ],
      ),
    );
  }
}
