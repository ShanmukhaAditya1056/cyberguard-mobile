import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/error_state_widget.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../provider/dashboard_provider.dart';
import '../widgets/module_card_widget.dart';
import '../widgets/quick_scan_button.dart';
import '../widgets/recent_alerts_widget.dart';
import '../widgets/score_ring_widget.dart';
import '../../malware/provider/malware_provider.dart';
import '../../wifi/provider/wifi_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreState = ref.watch(unifiedScoreProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', width: 28, height: 28),
            const SizedBox(width: 8),
            const Text('CyberGuard AI'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.go('/alerts'),
          ),
        ],
      ),
      floatingActionButton: QuickScanButton(
        onPressed: () async {
          await ref.read(malwareScanProvider.notifier).startScan();
          await ref.read(malwareAppsProvider.notifier).load();
          await ref.read(wifiScanProvider.notifier).scan();
          await ref.read(unifiedScoreProvider.notifier).refresh();
          ref.invalidate(dashboardStatsProvider);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(unifiedScoreProvider.notifier).refresh();
          ref.invalidate(dashboardStatsProvider);
        },
        child: statsAsync.when(
          loading: () => const LoadingWidget(message: 'Loading dashboard...'),
          error: (error, _) => ErrorStateWidget(
            message: 'Unable to load dashboard.',
            onRetry: () => ref.refresh(dashboardStatsProvider),
          ),
          data: (stats) {
            final lastScan = scoreState.lastScan == null
                ? 'Never scanned'
                : 'Last scan: ${scoreState.lastScan!.hour.toString().padLeft(2, '0')}:'
                    '${scoreState.lastScan!.minute.toString().padLeft(2, '0')}';
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Column(
                    children: [
                      ScoreRingWidget(score: scoreState.score, label: scoreState.label),
                      const SizedBox(height: 8),
                      Text(
                        scoreState.label,
                        style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(lastScan, style: const TextStyle(color: AppColors.textDim)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    ModuleCardWidget(
                      title: stats.modules[0].title,
                      status: stats.modules[0].statusLabel,
                      icon: Icons.link,
                      onTap: () => context.go(stats.modules[0].route),
                    ),
                    ModuleCardWidget(
                      title: stats.modules[1].title,
                      status: stats.modules[1].statusLabel,
                      icon: Icons.smartphone,
                      onTap: () => context.go(stats.modules[1].route),
                    ),
                    ModuleCardWidget(
                      title: stats.modules[2].title,
                      status: stats.modules[2].statusLabel,
                      icon: Icons.shield,
                      onTap: () => context.go(stats.modules[2].route),
                    ),
                    ModuleCardWidget(
                      title: stats.modules[3].title,
                      status: stats.modules[3].statusLabel,
                      icon: Icons.wifi,
                      onTap: () => context.go(stats.modules[3].route),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Recent Alerts',
                  style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                RecentAlertsWidget(alerts: stats.recentAlerts),
              ],
            );
          },
        ),
      ),
    );
  }
}
