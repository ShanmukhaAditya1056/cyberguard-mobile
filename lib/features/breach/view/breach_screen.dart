import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/cyber_button.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/error_state_widget.dart';
import '../provider/breach_provider.dart';
import '../widgets/breach_card_widget.dart';
import '../widgets/credential_input_widget.dart';
import '../widgets/privacy_note_widget.dart';

class BreachScreen extends ConsumerStatefulWidget {
  const BreachScreen({super.key});

  @override
  ConsumerState<BreachScreen> createState() => _BreachScreenState();
}

class _BreachScreenState extends ConsumerState<BreachScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(breachCheckProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Breach Monitor'),
          bottom: const TabBar(tabs: [Tab(text: 'Email'), Tab(text: 'Phone')]),
        ),
        body: TabBarView(
          children: [
            _buildTab(context, state),
            _buildTab(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, BreachState state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CredentialInputWidget(controller: _controller),
        const SizedBox(height: 12),
        CyberButton(
          label: 'Check Now',
          isLoading: state.isLoading,
          onPressed: () => ref.read(breachCheckProvider.notifier).check(_controller.text),
        ),
        const SizedBox(height: 12),
        const PrivacyNoteWidget(),
        const SizedBox(height: 12),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: const Text('How it works', style: TextStyle(color: AppColors.textWhite)),
          children: const [
            Text(
              '1. Your credential is hashed locally.\n'
              '2. Only the first 5 characters are sent.\n'
              '3. The API returns matching hash suffixes.\n'
              '4. A local match confirms a breach.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (state.isLoading)
          Column(
            children: [
              const CircularProgressIndicator(color: AppColors.accentBlue),
              const SizedBox(height: 8),
              Text(state.statusMessage, style: const TextStyle(color: AppColors.textMuted)),
            ],
          )
        else if (state.error != null)
          ErrorStateWidget(message: state.error!)
        else if (state.result == null)
          const EmptyStateWidget(
            title: 'No checks yet',
            subtitle: 'Enter a credential to start monitoring.',
            icon: Icons.security,
          )
        else ...[
          _buildResultCard(state),
          const SizedBox(height: 12),
          if (state.result!.breaches.isNotEmpty)
            Column(
              children: state.result!.breaches
                  .map((breach) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: BreachCardWidget(breach: breach),
                      ))
                  .toList(),
            ),
        ],
      ],
    );
  }

  Widget _buildResultCard(BreachState state) {
    final found = state.result!.found;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: found ? AppColors.dangerBg : AppColors.safeGreenBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(found ? Icons.warning : Icons.check_circle,
              color: found ? AppColors.dangerRed : AppColors.safeGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              found ? 'Breach found (${state.result!.count})' : 'No breach found',
              style: TextStyle(
                color: found ? AppColors.dangerRed : AppColors.safeGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (found)
            TextButton(
              onPressed: () => context.go('/breach/detail', extra: state.result),
              child: const Text('Details', style: TextStyle(color: AppColors.accentBlue)),
            ),
        ],
      ),
    );
  }
}
