import 'package:flutter/material.dart';

class StarfieldBackground extends StatelessWidget {
  final Widget child;

  const StarfieldBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Option 1: Asset image
        Image.asset(
          'assets/images/Black.jpg',
          fit: BoxFit.cover,
        ),  

        // Option 2: Network image (if hosted)
        // Image.network(
        //   'https://your-cdn.com/background.png',
        //   fit: BoxFit.cover,
        // ),

        child,
      ],
    );
  }
}