import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../data/models/alert_model.dart';
import '../provider/alerts_provider.dart';
import '../widgets/alert_card_widget.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final alerts = ref.watch(alertsProvider);
    final filtered = _applyFilter(alerts);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () => ref.read(alertsProvider.notifier).markAllRead(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFilters(),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            const EmptyStateWidget(
              title: 'No alerts',
              subtitle: 'You are all caught up.',
              icon: Icons.notifications,
            )
          else
            ...filtered.map(
              (alert) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Dismissible(
                  key: ValueKey(alert.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: AppColors.dangerRed,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => ref.read(alertsProvider.notifier).dismiss(alert.id),
                  child: AlertCardWidget(alert: alert),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    Widget chip(String label) {
      final selected = _filter == label;
      return ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _filter = label),
        selectedColor: AppColors.accentBlue,
        backgroundColor: AppColors.card,
        labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textMuted),
      );
    }

    return Wrap(
      spacing: 8,
      children: [
        chip('All'),
        chip('Critical'),
        chip('Warning'),
        chip('Safe'),
        chip('Info'),
      ],
    );
  }

  List<AlertModel> _applyFilter(List<AlertModel> alerts) {
    if (_filter == 'All') return alerts;
    final key = _filter.toUpperCase();
    return alerts.where((a) => a.type == key).toList();
  }
}
