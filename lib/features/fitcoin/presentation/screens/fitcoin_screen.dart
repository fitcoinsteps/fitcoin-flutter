import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/features/fitcoin/presentation/providers/fitcoin_providers.dart';
import 'package:fitcoin/features/fitcoin/presentation/states/fitcoin_states.dart';
import 'package:fitcoin/features/fitcoin/presentation/widgets/balance_card.dart';

class FitcoinScreen extends ConsumerStatefulWidget {
  const FitcoinScreen({super.key});

  @override
  ConsumerState<FitcoinScreen> createState() => _FitcoinScreenState();
}

class _FitcoinScreenState extends ConsumerState<FitcoinScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(fitcoinControllerProvider.notifier).loadBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fitcoinControllerProvider);

    ref.listen<FitcoinState>(fitcoinControllerProvider, (previous, current) {
      if (current is FitcoinError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(current.message), backgroundColor: Colors.red),
        );
      } else if (current is FitcoinSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Earned ${current.result.fitcoinsEarned} Fitcoins!'),
            backgroundColor: Colors.green,
          ),
        );
        Future.microtask(() {
          ref.read(fitcoinControllerProvider.notifier).loadBalance();
        });
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Fitcoin')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (state.balance != null)
              BalanceCard(balance: state.balance!)
            else if (state is FitcoinLoading)
              const Center(child: CircularProgressIndicator())
            else
              const SizedBox.shrink(),
            const SizedBox(height: 20),
            const Text(
              'Steps are automatically converted to Fitcoins.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}