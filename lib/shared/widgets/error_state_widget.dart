import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'cyber_button.dart';

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.dangerRed),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: AppColors.textWhite)),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            CyberButton(label: 'Retry', onPressed: onRetry),
          ],
        ],
      ),
    );
  }
}
