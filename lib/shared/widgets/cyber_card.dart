import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CyberCard extends StatelessWidget {
  const CyberCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderColor = AppColors.border,
    this.leftBorderColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color borderColor;
  final Color? leftBorderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: leftBorderColor == null
              ? null
              : Border(left: BorderSide(color: leftBorderColor!, width: 4)),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}
