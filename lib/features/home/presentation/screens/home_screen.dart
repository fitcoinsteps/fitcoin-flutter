import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitcoin/core/theme/app_colors.dart';
import 'package:fitcoin/core/theme/widgets/global_app_bar.dart';
import 'package:fitcoin/core/theme/widgets/starfield_background.dart';
import 'package:fitcoin/features/step_counter/presentation/providers/step_providers.dart';
import 'package:fitcoin/features/step_counter/presentation/states/step_states.dart';
import 'package:fitcoin/features/step_counter/presentation/widgets/step_progress_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize step counter on home load
    Future.microtask(() {
      ref.read(stepControllerProvider.notifier).init();
      ref.read(stepControllerProvider.notifier).startStepCounting();
    });
  }

  @override
  Widget build(BuildContext context) {
    final stepState = ref.watch(stepControllerProvider);

    return StarfieldBackground(
      child: Column(
        children: [
          GlobalAppBar(
            leading: GestureDetector(
              onTap: () => context.go('/profile'),
              child: const Icon(Icons.person_outline, color: Colors.white, size: 28),
            ),
            titleWidget: Text(
              'FITCOIN',
              style: TextStyle(
                color: AppColors.primaryPink,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    color: AppColors.primaryPink.withValues(alpha: 0.5),
                    blurRadius: 12,
                    offset: Offset.zero,
                  ),
                  Shadow(
                    color: AppColors.primaryPink.withValues(alpha: 0.2),
                    blurRadius: 24,
                    offset: Offset.zero,
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.monetization_on, color: AppColors.primaryPink, size: 22),
                  const SizedBox(width: 5),
                  const Text(
                    '1,250',
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to Fitcoin',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your fitness journey starts here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 30),

                  // Step Counter Card (if loaded)
                  if (stepState is StepLoaded)
                    StepProgressCard(stepData: stepState.stepData, isSyncing: stepState.isSyncing)
                  else if (stepState is StepLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (stepState is StepError)
                      Text(stepState.message, style: const TextStyle(color: Colors.red))
                    else
                      const SizedBox.shrink(),

                  const SizedBox(height: 20),

                  // Button to open full step dashboard
                  OutlinedButton.icon(
                    onPressed: () => context.push('/step-dashboard'),
                    icon: const Icon(Icons.directions_walk, color: AppColors.primaryPink),
                    label: const Text('View Step Counter', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryPink),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Button to open live tracking
                  OutlinedButton.icon(
                    onPressed: () => context.push('/tracking'),
                    icon: const Icon(Icons.map, color: AppColors.primaryPink),
                    label: const Text('Live Tracking', style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryPink),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}