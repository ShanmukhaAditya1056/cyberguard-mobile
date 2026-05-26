import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PrivacyNoteWidget extends StatelessWidget {
  const PrivacyNoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.safeGreenBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        'k-Anonymity: Only 5 hash characters sent. Your credential never leaves this device.',
        style: TextStyle(color: AppColors.safeGreen, fontSize: 12),
      ),
    );
  }
}
