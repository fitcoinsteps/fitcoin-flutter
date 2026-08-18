import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/anti_theft/presentation/providers/anti_theft_providers.dart';
import 'package:fitcoin/features/anti_theft/presentation/states/anti_theft_states.dart';

class AntiTheftScreen extends ConsumerWidget {
  const AntiTheftScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(antiTheftControllerProvider);
    final controller = ref.read(antiTheftControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Anti-Theft')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              state is AntiTheftArmed ? Icons.lock : Icons.lock_open,
              size: 80,
              color: state is AntiTheftArmed ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              state is AntiTheftArmed
                  ? 'Armed'
                  : state is AntiTheftDisarmed
                  ? 'Disarmed'
                  : 'Ready',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (state is AntiTheftArmed) {
                  controller.disarm();
                } else {
                  controller.arm();
                }
              },
              child: Text(state is AntiTheftArmed ? 'Disarm' : 'Arm'),
            ),
          ],
        ),
      ),
    );
  }
}