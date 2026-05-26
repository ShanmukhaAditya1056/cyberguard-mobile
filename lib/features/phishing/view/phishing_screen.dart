import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clipboard/clipboard.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/scan_result.dart';
import '../../../shared/widgets/cyber_button.dart';
import '../../../shared/widgets/error_state_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../provider/phishing_provider.dart';
import '../../settings/provider/settings_provider.dart';
import '../widgets/scan_history_widget.dart';
import '../widgets/shap_bar_widget.dart';
import '../widgets/url_input_widget.dart';

class PhishingScreen extends ConsumerStatefulWidget {
  const PhishingScreen({super.key});

  @override
  ConsumerState<PhishingScreen> createState() => _PhishingScreenState();
}

class _PhishingScreenState extends ConsumerState<PhishingScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phishingScanProvider);
    final history = ref.watch(phishingHistoryProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phishing Scanner'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          UrlInputWidget(controller: _controller),
          const SizedBox(height: 12),
          CyberButton(
            label: 'Scan',
            isLoading: state.isLoading,
            onPressed: () async {
              await ref.read(phishingScanProvider.notifier).scan(_controller.text);
              await ref.read(phishingHistoryProvider.notifier).load();
            },
          ),
          const SizedBox(height: 10),
          CyberButton(
            label: 'Auto-scan Clipboard',
            style: CyberButtonStyle.secondary,
            onPressed: settings.clipboardScanner
                ? () async {
              final text = await FlutterClipboard.paste();
              setState(() => _controller.text = text);
              await ref.read(phishingScanProvider.notifier).scan(text);
              await ref.read(phishingHistoryProvider.notifier).load();
                }
                : null,
          ),
          const SizedBox(height: 16),
          if (state.isLoading)
            Column(
              children: [
                const SizedBox(height: 16),
                const CircularProgressIndicator(color: AppColors.accentBlue),
                const SizedBox(height: 12),
                const Text('Analyzing...', style: TextStyle(color: AppColors.textMuted)),
                const SizedBox(height: 16),
              ],
            )
          else if (state.error != null)
            ErrorStateWidget(message: state.error!)
          else if (state.result != null)
            _buildResultCard(state.result!, context),
          const SizedBox(height: 20),
          const Text(
            'Recent Scans',
            style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          if (history.isEmpty)
            const EmptyStateWidget(
              title: 'No scans yet',
              subtitle: 'Run a scan to see your history.',
              icon: Icons.history,
            )
          else
            ScanHistoryWidget(history: history),
        ],
      ),
    );
  }

  Widget _buildResultCard(ScanResult result, BuildContext context) {
    final isPhishing = result.verdict == 'PHISHING';
    final color = isPhishing ? AppColors.dangerRed : AppColors.safeGreen;
    return Card(
      color: isPhishing ? AppColors.dangerBg : AppColors.safeGreenBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(isPhishing ? Icons.warning : Icons.check_circle, color: color),
                const SizedBox(width: 8),
                Text(result.verdict,
                    style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('${result.confidence.toStringAsFixed(0)}%',
                    style: TextStyle(color: color, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              result.explanation,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            if (isPhishing) ...[
              const SizedBox(height: 12),
              const Text('Top reasons',
                  style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Column(
                children: result.reasons.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ShapBarWidget(reason: r),
                )).toList(),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => context.go('/phishing/result', extra: result),
                child: const Text('View detailed result', style: TextStyle(color: AppColors.accentBlue)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
