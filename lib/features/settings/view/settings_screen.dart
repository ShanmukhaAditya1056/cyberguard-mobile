import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/app_provider.dart';
import '../../../shared/widgets/cyber_button.dart';
import '../../../shared/widgets/cyber_card.dart';
import '../provider/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Protection', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SwitchListTile(
            value: settings.realTimeAlerts,
            onChanged: (value) => ref.read(settingsProvider.notifier).updateRealTimeAlerts(value),
            title: const Text('Real-time alerts'),
          ),
          SwitchListTile(
            value: settings.clipboardScanner,
            onChanged: (value) => ref.read(settingsProvider.notifier).updateClipboardScanner(value),
            title: const Text('Clipboard scanner'),
          ),
          DropdownButtonFormField<String>(
            key: ValueKey(settings.autoScanFrequency),
            value: settings.autoScanFrequency,
            items: const [
              DropdownMenuItem(value: 'Daily', child: Text('Daily')),
              DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
              DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(settingsProvider.notifier).updateAutoScanFrequency(value);
              }
            },
            decoration: const InputDecoration(labelText: 'Auto scan frequency'),
          ),
          SwitchListTile(
            value: settings.wifiAutoScan,
            onChanged: (value) => ref.read(settingsProvider.notifier).updateWifiAutoScan(value),
            title: const Text('Wi-Fi auto scan'),
          ),
          const SizedBox(height: 16),
          const Text('Privacy', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const CyberCard(
            child: Text(
              'Device-only scans • Permissions required for real-time checks',
              style: TextStyle(color: AppColors.safeGreen, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          const ListTile(
            title: Text('Real-time device signals'),
            subtitle: Text('Installed apps, Wi-Fi details, clipboard, and alerts stay on device.'),
          ),
          const ListTile(
            title: Text('SHA-256 local encryption'),
            subtitle: Text('All sensitive data is encrypted on-device.'),
          ),
          const ListTile(
            title: Text('DPDPA 2023 compliant'),
            subtitle: Text('Built for India’s privacy standards.'),
          ),
          const SizedBox(height: 16),
          const Text('About', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const ListTile(title: Text('Version 2.0.0')),
          const ListTile(
            title: Text('ML Models'),
            subtitle: Text('DistilBERT, RF+LightGBM+GNN, Isolation Forest, SHAP'),
          ),
          const ListTile(
            title: Text('Accuracy'),
            subtitle: Text('Accuracy depends on device context and permissions granted.'),
          ),
          const SizedBox(height: 16),
          const Text('Permissions', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          CyberButton(
            label: 'Grant Permissions',
            style: CyberButtonStyle.secondary,
            onPressed: () async {
              await ref.read(permissionServiceProvider).requestAll();
            },
          ),
          ListTile(
            title: const Text('Rate app'),
            onTap: () async {
              await launchUrl(Uri.parse('https://play.google.com/store'));
            },
          ),
          ListTile(
            title: const Text('Share app'),
            onTap: () => Share.share('Try CyberGuard AI for secure mobile protection.'),
          ),
          const ListTile(
            title: Text('Compliance'),
            subtitle: Text('CERT-In, RBI Cyber Security Framework, DPDPA 2023'),
          ),
          const SizedBox(height: 16),
          CyberButton(
            label: 'Clear All Data',
            style: CyberButtonStyle.danger,
            onPressed: () => _confirmClear(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all data?'),
        content: const Text('This will remove all scans, alerts, and settings.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Clear')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(localStorageProvider).clearAll();
      await ref.read(settingsProvider.notifier).reset();
    }
  }
}
