import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitcoin/features/logout/presentation/providers/logout_providers.dart';
import 'package:fitcoin/features/logout/presentation/states/logout_states.dart';

class LogoutButton extends ConsumerStatefulWidget {
  final bool showAllDevicesOption;

  const LogoutButton({
    super.key,
    this.showAllDevicesOption = true,
  });

  @override
  ConsumerState<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends ConsumerState<LogoutButton> {
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout All Devices'),
        content: const Text(
          'Are you sure you want to logout from all devices?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout All',
              style: TextStyle(color: Colors.orange),
            ),
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: isLoading ? null : _logout,
          icon: isLoading
              ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : const Icon(Icons.logout),
          label: const Text('Logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        if (widget.showAllDevicesOption) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: isLoading ? null : _logoutAllDevices,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ],
    );
  }
}