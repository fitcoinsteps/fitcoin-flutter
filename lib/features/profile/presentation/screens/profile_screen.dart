import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitcoin/core/theme/widgets/global_app_bar.dart';
import 'package:fitcoin/core/theme/widgets/starfield_background.dart';
import 'package:fitcoin/features/logout/presentation/providers/logout_providers.dart';
import 'package:fitcoin/features/logout/presentation/states/logout_states.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoggedIn = false;
  bool _checkingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // Change 'token' to your actual token key if different.
    final token = prefs.getString('token');

    if (!mounted) return;

    setState(() {
      _isLoggedIn = token != null && token.isNotEmpty;
      _checkingAuth = false;
    });
  }

  Future<void> _logout() async {
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

  Future<void> _logoutAllDevices() async {
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

    return StarfieldBackground(
      child: Column(
        children: [
          const GlobalAppBar(
            title: 'Profile',
          ),

          Expanded(
            child: Center(
              child: _checkingAuth
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : _isLoggedIn
                  ? _buildLoggedInProfile(isLoading)
                  : _buildLoginProfile(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginProfile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.person_outline,
          size: 80,
          color: Colors.white70,
        ),

        const SizedBox(height: 24),

        const Text(
          'You are not logged in',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Login to access your profile.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 32),

        ElevatedButton.icon(
          onPressed: () {
            context.go('/login');
          },
          icon: const Icon(Icons.login),
          label: const Text('Login'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoggedInProfile(bool isLoading) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.person,
          size: 80,
          color: Colors.white70,
        ),

        const SizedBox(height: 24),

        const Text(
          'Profile Screen',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 32),

        if (isLoading)
          const CircularProgressIndicator(
            color: Colors.white,
          )
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
            icon: const Icon(
              Icons.logout,
              color: Colors.orange,
            ),
            label: const Text(
              'Logout All Devices',
              style: TextStyle(
                color: Colors.orange,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Colors.orange,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}