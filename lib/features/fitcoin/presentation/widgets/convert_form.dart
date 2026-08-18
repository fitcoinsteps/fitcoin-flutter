import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitcoin/core/theme/widgets/gradient_button.dart';
import 'package:fitcoin/features/fitcoin/presentation/providers/fitcoin_providers.dart';
import 'package:fitcoin/features/fitcoin/presentation/states/fitcoin_states.dart';

class ConvertForm extends ConsumerStatefulWidget {
  const ConvertForm({super.key});

  @override
  ConsumerState<ConvertForm> createState() => _ConvertFormState();
}

class _ConvertFormState extends ConsumerState<ConvertForm> {
  final _formKey = GlobalKey<FormState>();
  final _stepsController = TextEditingController();

  @override
  void dispose() {
    _stepsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final steps = int.tryParse(_stepsController.text.trim());
    if (steps == null || steps <= 0) return;

    ref.read(fitcoinControllerProvider.notifier).convertSteps(steps);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fitcoinControllerProvider);
    final isLoading = state is FitcoinConverting;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _stepsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Steps to convert',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.directions_walk),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter steps';
              final steps = int.tryParse(value);
              if (steps == null || steps <= 0) return 'Invalid number';
              return null;
            },
          ),
          const SizedBox(height: 16),
          GradientButton(
            label: 'Convert',
            isLoading: isLoading,
            onPressed: isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }
}