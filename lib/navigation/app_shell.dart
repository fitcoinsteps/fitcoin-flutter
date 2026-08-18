import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitcoin/core/theme/widgets/global_bottom_nav_bar.dart';

final selectedTabProvider = StateProvider<int>((ref) => 0);

class AppShell extends ConsumerStatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  // We start with index 0 (Home) – no need to read the current route.
  @override
  void initState() {
    super.initState();
    // Optionally set the initial tab to match the initial location
    // if you want to sync on first load, but we can just keep 0.
    // If you want to sync, you can use WidgetsBinding to get the
    // initial route from the router, but it's not necessary.
  }

  void _onTabTapped(int index) {
    ref.read(selectedTabProvider.notifier).state = index;

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/profile');
        break;
      case 2:
        context.go('/earnings');
        break;
      case 3:
        context.go('/rewards');
        break;
      default:
        context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedTabProvider);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: GlobalBottomNavBar(
        currentIndex: selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}