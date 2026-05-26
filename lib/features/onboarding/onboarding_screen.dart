import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/providers/app_provider.dart';
import '../../shared/widgets/cyber_button.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<Map<String, String>> _pages = const [
    {
      'icon': '🇮🇳',
      'title': 'Built for India',
      'description':
          'Detects UPI fraud, fake Aadhaar KYC SMS and TRAI impersonation — threats that global apps completely miss',
    },
    {
      'icon': '📴',
      'title': 'On-device, real-time',
      'description':
          'Scans use device permissions and on-device AI. No backend needed for core protections.',
    },
    {
      'icon': '💡',
      'title': 'Explains Every Threat',
      'description': 'SHAP AI tells you exactly WHY something is dangerous — plain language every time',
    },
    {
      'icon': '💰',
      'title': 'Free Forever',
      'description': 'No subscription. No ads. No data collection. Enterprise-grade security at Rs. 0',
    },
  ];

  Future<void> _completeOnboarding() async {
    await ref.read(permissionServiceProvider).requestAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    await ref.read(localStorageProvider).setOnboardingComplete(true);
    if (!mounted) return;
    context.go('/dashboard');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: OnboardingPage(
                      key: ValueKey(page['title']),
                      icon: page['icon']!,
                      title: page['title']!,
                      description: page['description']!,
                    ),
                  );
                },
              ),
            ),
            _buildIndicators(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _index == _pages.length - 1
                    ? CyberButton(
                        key: const ValueKey('get-started'),
                        label: 'Get Started',
                        onPressed: _completeOnboarding,
                      )
                    : Row(
                        key: const ValueKey('controls'),
                        children: [
                          TextButton(
                            onPressed: _completeOnboarding,
                            child: const Text('Skip', style: TextStyle(color: AppColors.textMuted)),
                          ),
                          const Spacer(),
                          CyberButton(
                            label: 'Next',
                            onPressed: () => _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _index == index ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _index == index ? AppColors.accentBlue : AppColors.border,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
