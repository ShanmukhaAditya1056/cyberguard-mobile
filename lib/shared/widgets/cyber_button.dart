import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

enum CyberButtonStyle { primary, secondary, danger }

class CyberButton extends StatelessWidget {
  const CyberButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = CyberButtonStyle.primary,
    this.isLoading = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final CyberButtonStyle style;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors();
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isLoading
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );
  }

  _ButtonColors _resolveColors() {
    switch (style) {
      case CyberButtonStyle.secondary:
        return _ButtonColors(AppColors.border, AppColors.accentBlue);
      case CyberButtonStyle.danger:
        return _ButtonColors(AppColors.dangerBg, AppColors.dangerRed);
      case CyberButtonStyle.primary:
        return _ButtonColors(AppColors.accentBlue, Colors.white);
    }
  }
}

class _ButtonColors {
  final Color background;
  final Color foreground;

  const _ButtonColors(this.background, this.foreground);
}
