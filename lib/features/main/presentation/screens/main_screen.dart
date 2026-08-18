import 'package:flutter/material.dart';
import 'package:fitcoin/core/theme/widgets/global_bottom_nav_bar.dart';
import 'package:fitcoin/features/home/presentation/screens/home_screen.dart';
import 'package:fitcoin/features/earnings/presentation/screens/earnings_screen.dart';
import 'package:fitcoin/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:fitcoin/features/profile/presentation/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    debugPrint('Swiped to tab $index'); // verify swipe works
  }

  void _onNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        // Enable drag – this is the default, but explicit helps
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          HomeScreen(),
          EarningsScreen(),
          RewardsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: GlobalBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}