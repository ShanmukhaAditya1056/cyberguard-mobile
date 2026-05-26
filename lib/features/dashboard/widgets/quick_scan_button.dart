import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class QuickScanButton extends StatelessWidget {
  const QuickScanButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.accentBlue,
      onPressed: onPressed,
      child: const Icon(Icons.shield, color: Colors.white),
    );
  }
}
