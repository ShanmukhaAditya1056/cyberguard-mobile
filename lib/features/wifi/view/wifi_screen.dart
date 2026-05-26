import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/cyber_button.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/error_state_widget.dart';
import '../provider/wifi_provider.dart';
import '../widgets/security_check_row.dart';
import '../widgets/trust_score_gauge.dart';

class WifiScreen extends ConsumerWidget {
  const WifiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wifiScanProvider);
    final result = state.result;

    return Scaffold(
      appBar: AppBar(title: const Text('Wi-Fi Scanner')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (result != null) ...[
            Text(result.ssid, style: const TextStyle(color: AppColors.textWhite, fontSize: 18)),
            const SizedBox(height: 8),
            TrustScoreGauge(score: result.score, label: result.label),
            const SizedBox(height: 12),
            Column(
              children: result.checks
                  .map((check) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SecurityCheckRow(label: check.label, status: check.status),
                      ))
                  .toList(),
            ),
            if (result.score < 30) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.criticalBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Disconnect immediately. This network is highly insecure.',
                  style: TextStyle(color: AppColors.critical),
                ),
              ),
            ],
          ] else if (state.isLoading)
            const Center(child: CircularProgressIndicator(color: AppColors.accentBlue))
          else if (state.error != null)
            ErrorStateWidget(message: state.error!)
          else
            const EmptyStateWidget(
              title: 'No scan yet',
              subtitle: 'Tap scan to analyze your Wi-Fi network.',
              icon: Icons.wifi,
            ),
          const SizedBox(height: 12),
          CyberButton(
            label: 'Scan Network',
            isLoading: state.isLoading,
            onPressed: () => ref.read(wifiScanProvider.notifier).scan(),
          ),
          const SizedBox(height: 20),
          const Text('Recent Networks',
              style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          if (state.history.isEmpty)
            const Text('No history yet', style: TextStyle(color: AppColors.textMuted))
          else
            Column(
              children: state.history
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border, width: 0.5),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.wifi, color: item.score >= 70 ? AppColors.safeGreen : AppColors.warningAmber),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(item.ssid,
                                    style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
                              ),
                              Text('${item.score}', style: const TextStyle(color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
