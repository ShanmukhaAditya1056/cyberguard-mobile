import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/scan_result.dart';
import '../widgets/shap_bar_widget.dart';

class PhishingResultScreen extends StatelessWidget {
  const PhishingResultScreen({super.key, required this.result});

  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    final isPhishing = result.verdict == 'PHISHING';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phishing Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            result.input,
            style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPhishing ? AppColors.dangerBg : AppColors.safeGreenBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(isPhishing ? Icons.warning : Icons.check_circle,
                    color: isPhishing ? AppColors.dangerRed : AppColors.safeGreen),
                const SizedBox(width: 8),
                Text(
                  result.verdict,
                  style: TextStyle(
                    color: isPhishing ? AppColors.dangerRed : AppColors.safeGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '${result.confidence.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: isPhishing ? AppColors.dangerRed : AppColors.safeGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(result.explanation, style: const TextStyle(color: AppColors.textMuted)),
          if (isPhishing) ...[
            const SizedBox(height: 16),
            const Text('Why this looks risky',
                style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...result.reasons.map(
              (reason) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ShapBarWidget(reason: reason),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
