import 'package:flutter/material.dart';
import 'package:fitcoin/core/theme/widgets/global_app_bar.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        GlobalAppBar(title: 'Earnings'),
        Expanded(
          child: Center(
            child: Text(
              'Earnings Screen',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}