import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class CyberAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CyberAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = false,
    this.onBack,
  });

  final String title;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textMuted),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Text(title),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
