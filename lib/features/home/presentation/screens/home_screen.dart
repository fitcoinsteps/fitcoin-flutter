import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitcoin/core/theme/app_colors.dart';
import 'package:fitcoin/core/theme/widgets/global_app_bar.dart';
import 'package:fitcoin/core/theme/widgets/starfield_background.dart';

// Step counter
import 'package:fitcoin/features/step_counter/presentation/providers/step_providers.dart';
import 'package:fitcoin/features/step_counter/presentation/states/step_states.dart';
import 'package:fitcoin/features/step_counter/presentation/widgets/step_progress_card.dart';

// Fitcoin balance
import 'package:fitcoin/features/fitcoin/presentation/providers/fitcoin_providers.dart';
import 'package:fitcoin/features/fitcoin/presentation/states/fitcoin_states.dart';

// Login state
import 'package:fitcoin/features/login_auth/presentation/providers/login_providers.dart';
import 'package:fitcoin/features/login_auth/presentation/states/login_states.dart';

// Sub-pages for the new cards
import 'package:fitcoin/features/earnings/presentation/screens/earnings_screen.dart';
import 'package:fitcoin/features/scratch_card/presentation/screens/scratch_card_screen.dart';

import 'package:fitcoin/features/spin/presentation/screens/spin_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // ----------------------------------------------------------------------
  // State variables from new design (daily rewards & ads)
  // ----------------------------------------------------------------------
  static const List<int> _dailyRewards = [5, 10, 10, 20, 30, 50, 100];
  static const int _totalDays = 7;
  static const Color _neonPink = Color(0xFFD946EF);
  static const Color _neonPurple = Color(0xFF8B5CF6);
  static const Color _neonGold = Color(0xFFFFD93D);
  static const Color _neonBlue = Color(0xFF1E90FF);
  static const Color _neonGreen = Color(0xFF00E676);
  static const Color _neonRed = Color(0xFFFF6B6B);

  int _currentDay = 1; // For demonstration; you can load from backend later
  final int _currentUserLevel = 5;
  final List<bool> _watchedAds = [false, false, false];

  // ----------------------------------------------------------------------
  // Init state (keeping your existing logic)
  // ----------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(stepControllerProvider.notifier).init();
      ref.read(stepControllerProvider.notifier).startStepCounting();
      ref.read(fitcoinControllerProvider.notifier).loadBalance();
    });
  }

  // ----------------------------------------------------------------------
  // Navigation helper (for pushing screens without GoRouter)
  // ----------------------------------------------------------------------
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  // ----------------------------------------------------------------------
  // Watch ads bottom sheet (from new design)
  // ----------------------------------------------------------------------
  void _showAdsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final hasAvailableAd = _watchedAds.any((watched) => !watched);
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF14141E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Center(
                    child: Text(
                      'Watch Ads & Earn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Watch 3 ads daily to earn 50 FIT',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(3, (index) {
                    final isWatched = _watchedAds[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(
                            isWatched ? 0.08 : 0.05,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isWatched
                                ? Colors.green.withOpacity(0.3)
                                : Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isWatched
                                  ? Icons.check_circle
                                  : Icons.play_circle_outline,
                              color: isWatched ? Colors.green : Colors.white24,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                isWatched
                                    ? 'Ad ${index + 1} (Watched)'
                                    : 'Ad ${index + 1} (Pending)',
                                style: TextStyle(
                                  color: isWatched
                                      ? Colors.white
                                      : Colors.white38,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (isWatched)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.green.withOpacity(0.2),
                                  ),
                                ),
                                child: const Text(
                                  '+ 15 FIT',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  Opacity(
                    opacity: hasAvailableAd ? 1.0 : 0.5,
                    child: GestureDetector(
                      onTap: hasAvailableAd
                          ? () {
                              final index = _watchedAds.indexWhere(
                                (watched) => !watched,
                              );
                              if (index != -1) {
                                setState(() {
                                  _watchedAds[index] = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('🎉 +15 FIT earned!'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E90FF), Color(0xFF00BFFF)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            hasAvailableAd
                                ? 'Watch Next Ad'
                                : 'All Ads Watched! 🎉',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ----------------------------------------------------------------------
  // Build method
  // ----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final stepState = ref.watch(stepControllerProvider);
    final fitcoinState = ref.watch(fitcoinControllerProvider);
    final loginState = ref.watch(loginProvider);

    String fullName = 'User';
    if (loginState is LoginSuccess) {
      final user = loginState.response.user;
      final first = user.firstName.trim();
      final last = user.lastName.trim();
      final combined = '$first $last'.trim();
      fullName = combined.isNotEmpty ? combined : user.username;
    }

    final int fitcoinBalance = fitcoinState.balance?.fitcoinBalance ?? 0;

    return StarfieldBackground(
      child: Column(
        children: [
          GlobalAppBar(
            leading: null,
            titleWidget: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: AppColors.primaryPink,
                    size: 22,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '$fitcoinBalance',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 10,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ==========================================================
                  // STEP COUNTER (kept exactly in the same position)
                  // ==========================================================
                  if (stepState is StepLoaded)
                    StepProgressCard(
                      stepData: stepState.stepData,
                      isSyncing: stepState.isSyncing,
                    )
                  else if (stepState is StepLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (stepState is StepError)
                    Text(
                      stepState.message,
                      style: const TextStyle(color: Colors.red),
                    )
                  else
                    const SizedBox.shrink(),

                  const SizedBox(height: 24),

                  // ==========================================================
                  // DAILY REWARDS ROW (from new design)
                  // ==========================================================
                  _buildDailyRewardsRow(),

                  const SizedBox(height: 20),

                  // ==========================================================
                  // LIVE TRACKING CARD (from new design)
                  // ==========================================================
                  _buildLiveTrackingCard(),

                  const SizedBox(height: 20),

                  // ==========================================================
                  // GRID OF PREMIUM CARDS (Earnings, Watch, Scratch, Spin)
                  // ==========================================================
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: [
                      _buildPremiumCard(
                        icon: Icons.attach_money,
                        title: 'Earnings',
                        color: _neonGold,
                        gradient: const [Color(0xFFFFD93D), Color(0xFFFFA000)],
                        onTap: () =>
                            _navigateTo(context, const EarningsScreen()),
                        label: 'View',
                      ),
                      _buildPremiumCard(
                        icon: Icons.play_circle_outline,
                        title: 'Watch Videos',
                        color: _neonBlue,
                        gradient: const [Color(0xFF1E90FF), Color(0xFF00BFFF)],
                        onTap: () => _showAdsBottomSheet(context),
                        label: 'Watch',
                        badge: '2x',
                      ),
                      _buildPremiumCard(
                        icon: Icons.credit_card,
                        title: 'Scratch Card',
                        color: _neonGreen,
                        gradient: const [Color(0xFF00E676), Color(0xFF059669)],
                        onTap: () =>
                            _navigateTo(context, const ScratchCardScreen()),
                        label: 'Scratch',
                      ),
                      _buildPremiumCard(
                        icon: Icons.casino_outlined,
                        title: 'Lucky Spin',
                        color: _neonRed,
                        gradient: const [Color(0xFFFF6B6B), Color(0xFFEF4444)],
                        onTap: () => _navigateTo(context, const SpinScreen()),
                        label: 'Spin',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ==========================================================
                  // INVITE CARD (from new design)
                  // ==========================================================
                  _buildInviteCardNew(),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // Daily rewards row (adapted from new design, without the big circle)
  // ----------------------------------------------------------------------
  Widget _buildDailyRewardsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_totalDays, (index) {
          final int day = index + 1;
          final int reward = _dailyRewards[index];
          final bool isActive = day == _currentDay;

          return Container(
            width: 55,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? _neonPurple.withOpacity(0.2)
                  : Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive
                    ? _neonPurple.withOpacity(0.6)
                    : Colors.white.withOpacity(0.08),
                width: isActive ? 1.5 : 0.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Day $day',
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.white60,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '+$reward',
                  style: TextStyle(
                    color: _neonPink,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (isActive)
                  InkWell(
                    onTap: () => _showAdsBottomSheet(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: _neonPurple.withOpacity(0.2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Claim',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else if (day < _currentDay)
                  const Icon(Icons.check_circle, color: Colors.green, size: 10)
                else
                  const Icon(Icons.lock, color: Colors.white24, size: 10),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // Live tracking card (from new design)
  // ----------------------------------------------------------------------
  Widget _buildLiveTrackingCard() {
    return GestureDetector(
      onTap: () => context.push('/tracking'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A0A2E), Color(0xFF0D0520)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _neonPurple.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: _neonPurple.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _neonPurple.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: _neonPurple.withOpacity(0.2)),
              ),
              child: const Icon(
                Icons.location_on,
                color: AppColors.primaryPurple,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Live Tracking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Live',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD93D), Color(0xFFFFA000)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD93D).withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Start Tracking →',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // Premium card (from new design)
  // ----------------------------------------------------------------------
  Widget _buildPremiumCard({
    required IconData icon,
    required String title,
    required Color color,
    required List<Color> gradient,
    required VoidCallback onTap,
    required String label,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0A12).withOpacity(0.8),
              color.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.15), width: 0.5),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.05), blurRadius: 20),
          ],
        ),
        child: Stack(
          children: [
            if (badge != null)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00E676), Colors.green],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: color.withOpacity(0.2)),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(height: 12),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradient),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: gradient.first.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  // Invite card (new design, renamed to avoid conflict)
  // ----------------------------------------------------------------------
  Widget _buildInviteCardNew() {
    const Color glowColor = Color(0xFFFFD93D);

    return GestureDetector(
      onTap: () => context.push('/invite'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A0A).withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: glowColor.withOpacity(0.2), width: 0.5),
          boxShadow: [
            BoxShadow(color: glowColor.withOpacity(0.1), blurRadius: 20),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: glowColor.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: glowColor.withOpacity(0.2)),
              ),
              child: Icon(Icons.card_giftcard, color: glowColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Invite Friend & Win Big! 🎉',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Share your referral code and earn rewards',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD93D), Color(0xFFFFA000)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD93D).withOpacity(0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Invite Now →',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
