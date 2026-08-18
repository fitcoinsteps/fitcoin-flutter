import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/step_counter/presentation/providers/step_providers.dart';
import 'package:fitcoin/features/step_counter/presentation/states/step_states.dart';
import 'package:fitcoin/features/step_counter/presentation/widgets/step_progress_card.dart';

class StepDashboardScreen extends ConsumerStatefulWidget {
  const StepDashboardScreen({super.key});

  @override
  ConsumerState<StepDashboardScreen> createState() => _StepDashboardScreenState();
}

class _StepDashboardScreenState extends ConsumerState<StepDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(stepControllerProvider.notifier).init();
      ref.read(stepControllerProvider.notifier).startStepCounting();
    });
  }

  @override
  Widget build(BuildContext context) {
    final stepState = ref.watch(stepControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Counter'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            stepState is StepLoaded
                ? StepProgressCard(
              stepData: stepState.stepData,
              isSyncing: stepState.isSyncing,
            )
                : stepState is StepLoading
                ? const CircularProgressIndicator()
                : stepState is StepError
                ? Text(stepState.message)
                : const SizedBox.shrink(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(stepControllerProvider.notifier).syncNow();
              },
              icon: const Icon(Icons.sync),
              label: const Text('Sync Now'),
            ),
          ],
        ),
      ),
    );
  }
}