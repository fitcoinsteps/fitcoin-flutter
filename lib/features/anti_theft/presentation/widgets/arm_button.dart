import 'package:flutter/material.dart';

class ArmButton extends StatelessWidget {
  final bool isArmed;
  final VoidCallback onPressed;

  const ArmButton({super.key, required this.isArmed, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(isArmed ? Icons.lock : Icons.lock_open),
      label: Text(isArmed ? 'Disarm' : 'Arm'),
    );
  }
}