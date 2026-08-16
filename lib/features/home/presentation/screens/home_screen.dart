import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitcoin/features/logout/presentation/providers/logout_providers.dart';
import 'package:fitcoin/features/logout/presentation/states/logout_states.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _logout() async {
    final notifier = ref.read(logoutProvider.notifier);
    await notifier.logout();

    if (!mounted) return;

    final state = ref.read(logoutProvider);
    switch (state) {
      case LogoutInitial():
        break;
      case LogoutLoading():
        break;
      case LogoutSuccess():
        context.go('/login');
        break;
      case LogoutError(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        break;
    }
  }

  void _logoutAllDevices() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout All Devices'),
        content: const Text('Are you sure you want to logout from all devices?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout All'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;

    final notifier = ref.read(logoutProvider.notifier);
    await notifier.logoutAllDevices();

    if (!mounted) return;

    final state = ref.read(logoutProvider);
    switch (state) {
      case LogoutInitial():
        break;
      case LogoutLoading():
        break;
      case LogoutSuccess():
        context.go('/login');
        break;
      case LogoutError(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoutState = ref.watch(logoutProvider);
    final isLoading = logoutState is LogoutLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              } else if (value == 'logout_all') {
                _logoutAllDevices();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout_all',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Logout All Devices'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.home,
                size: 80,
                color: Colors.indigo,
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to Fitcoin',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your fitness journey starts here.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              if (isLoading)
                const CircularProgressIndicator()
              else ...[
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _logoutAllDevices,
                  icon: const Icon(Icons.logout, color: Colors.orange),
                  label: const Text(
                    'Logout All Devices',
                    style: TextStyle(color: Colors.orange),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}