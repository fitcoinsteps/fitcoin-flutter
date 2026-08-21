// lib/features/rewards/presentation/screens/rewards_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitcoin/core/theme/app_colors.dart';
import 'package:fitcoin/core/theme/widgets/global_app_bar.dart';
import 'package:fitcoin/core/theme/widgets/starfield_background.dart';
import 'package:fitcoin/core/cache/cache_service.dart';

// Fitcoin balance
import 'package:fitcoin/features/fitcoin/presentation/providers/fitcoin_providers.dart';
import 'package:fitcoin/features/fitcoin/presentation/states/fitcoin_states.dart';
import 'package:fitcoin/features/fitcoin/domain/entities/fitcoin_balance.dart';

// Login state
import 'package:fitcoin/features/login_auth/presentation/providers/login_providers.dart';
import 'package:fitcoin/features/login_auth/presentation/states/login_states.dart';

class RewardsScreen extends ConsumerStatefulWidget {
  const RewardsScreen({super.key});

  @override
  ConsumerState<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends ConsumerState<RewardsScreen> {
  final Color _accentPink = const Color(0xFFD946EF);
  final Color _accentPurple = const Color(0xFF8B5CF6);
  final Color _accentGold = const Color(0xFFFFD93D);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _loadBalance();
    });
  }

  Future<void> _loadBalance() async {
    if (_isLoading) return;
    _isLoading = true;

    if (CacheService.isTokenExpired()) {
      print('🔴 Token expired, attempting refresh...');
    }

    await ref.read(fitcoinControllerProvider.notifier).loadBalance();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final fitcoinState = ref.watch(fitcoinControllerProvider);
    final loginState = ref.watch(loginProvider);

    ref.listen<FitcoinState>(fitcoinControllerProvider, (previous, current) {
      if (current is FitcoinError) {
        if (current.message.contains('401') ||
            current.message.contains('Unauthorized') ||
            current.message.contains('Session expired')) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!_isLoading) {
              _loadBalance();
            }
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(current.message),
            backgroundColor: Colors.red,
          ),
        );
      } else if (current is FitcoinSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Earned ${current.result.fitcoinsEarned} Fitcoins! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
        Future.microtask(() {
          ref.read(fitcoinControllerProvider.notifier).loadBalance();
        });
      }
    });

    return StarfieldBackground(
      child: Column(
        children: [
          GlobalAppBar(
            leading: null,
            titleWidget: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Rewards',
                style: TextStyle(
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
                  Icon(Icons.monetization_on, color: AppColors.primaryPink, size: 22),
                  const SizedBox(width: 5),
                  Text(
                    '${fitcoinState.balance?.fitcoinBalance ?? 0}',
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
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (fitcoinState is FitcoinLoading && fitcoinState.balance == null)
                    _buildLoadingState()
                  else if (fitcoinState is FitcoinError)
                    _buildErrorState(fitcoinState.message)
                  else if (fitcoinState.balance != null)
                      _buildPremiumWalletCard(fitcoinState.balance!)
                    else
                      const SizedBox.shrink(),
                  const SizedBox(height: 28),

                  Text(
                    'Withdraw Crypto',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _buildWithdrawUSDT(),
                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Redeem Gift Cards',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      InkWell(
                        onTap: () => _showAllCardsBottomSheet(),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _accentPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _accentPurple.withOpacity(0.2)),
                          ),
                          child: Text(
                            'View All',
                            style: TextStyle(color: _accentPurple, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildHorizontalGiftCardCarousel(),
                  const SizedBox(height: 28),

                  Text(
                    'Recent Activity',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _buildCompactHistory(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // Loading State
  // ==========================================================================
  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFF14141E),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _accentPink.withOpacity(0.2), width: 1),
      ),
      child: const Center(
        child: Column(
          children: [
            CircularProgressIndicator(color: Color(0xFFD946EF)),
            SizedBox(height: 16),
            Text(
              'Loading balance...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // Error State
  // ==========================================================================
  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF14141E),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _loadBalance,
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentPink,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // Premium Wallet Card (includes steps and conversion rate)
  // ==========================================================================
  Widget _buildPremiumWalletCard(FitcoinBalance balance) {
    final double fitcoinBalance = balance.fitcoinBalance.toDouble();
    final double usdtValue = fitcoinBalance / 1000.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF14141E),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _accentPink.withOpacity(0.7), width: 1.5),
        boxShadow: [BoxShadow(color: _accentPink.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -30,
            right: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [_accentPink.withOpacity(0.15), Colors.transparent],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined, color: Colors.white70, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Main Wallet',
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => context.push('/history'),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _accentPink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _accentPink.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.history, color: _accentPink, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'History',
                            style: TextStyle(color: _accentPink, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Balance',
                          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${fitcoinBalance.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5),
                            ),
                            const SizedBox(width: 6),
                            const Text('FIT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white54)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '≈ ${usdtValue.toStringAsFixed(2)} USDT',
                          style: TextStyle(color: _accentGold.withOpacity(0.8), fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/Wallet.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)],
                              ),
                            ),
                            child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 40),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ---- Steps & conversion info ----
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.directions_walk, color: _accentPink, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Today\'s Steps',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                        ),
                      ],
                    ),
                    Text(
                      '${balance.todayAvailableSteps}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.swap_horiz, color: _accentGold, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Conversion Rate',
                          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                        ),
                      ],
                    ),
                    Text(
                      '${balance.conversionRate} steps = 1 FIT',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // Withdraw USDT
  // ==========================================================================
  Widget _buildWithdrawUSDT() {
    return InkWell(
      onTap: () => _showWithdrawBottomSheet(),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF14141E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _accentGold.withOpacity(0.6), width: 1.5),
          boxShadow: [BoxShadow(color: _accentGold.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _accentGold.withOpacity(0.15),
                border: Border.all(color: _accentGold.withOpacity(0.2)),
              ),
              child: Icon(Icons.attach_money, color: _accentGold, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('USDT (ERC-20)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  const Text('Min: 5 USDT · No Fees', style: TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFFD93D), Color(0xFFF59E0B)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: _accentGold.withOpacity(0.3), blurRadius: 10)],
              ),
              child: const Text('Withdraw', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // Withdraw Bottom Sheet
  // ==========================================================================
  void _showWithdrawBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
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
              const SizedBox(height: 24),

              const Center(
                child: Text(
                  'Withdraw USDT',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Minimum withdrawal is 5.00 USDT',
                  style: TextStyle(color: _accentGold.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Amount',
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: '5.00',
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFD946EF)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: _accentGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _accentGold.withOpacity(0.2)),
                    ),
                    child: Text(
                      'MAX',
                      style: TextStyle(color: _accentGold, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                'Network',
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ERC-20 (Ethereum)', style: TextStyle(color: Colors.white)),
                    Icon(Icons.keyboard_arrow_down, color: Colors.white.withOpacity(0.5)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Wallet Address',
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '0x...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD946EF)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: const Color(0xFFD946EF).withOpacity(0.3), blurRadius: 10)],
                ),
                child: const Center(
                  child: Text(
                    'Confirm Withdrawal',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================================
  // Gift Card Carousel
  // ==========================================================================
  Widget _buildHorizontalGiftCardCarousel() {
    final List<Map<String, dynamic>> brands = [
      {
        'title': 'Amazon',
        'icon': Icons.shopping_bag_outlined,
        'color': const Color(0xFFFF9900),
        'gradient': [const Color(0xFF331A00).withOpacity(0.7), const Color(0xFF14141E)],
      },
      {
        'title': 'Apple',
        'icon': Icons.apple,
        'color': Colors.grey,
        'gradient': [const Color(0xFF2A2A2A).withOpacity(0.6), const Color(0xFF14141E)],
      },
      {
        'title': 'Steam',
        'icon': Icons.gamepad,
        'color': const Color(0xFF171A21),
        'gradient': [const Color(0xFF152238).withOpacity(0.7), const Color(0xFF14141E)],
      },
      {
        'title': 'Google Play',
        'icon': Icons.android,
        'color': const Color(0xFF34A853),
        'gradient': [const Color(0xFF113019).withOpacity(0.6), const Color(0xFF14141E)],
      },
    ];

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          final brand = brands[index];
          return GestureDetector(
            onTap: () {
              _showRedeemBottomSheet(
                title: brand['title'],
                icon: brand['icon'],
                color: brand['color'],
              );
            },
            child: Container(
              width: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: brand['gradient'],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _accentPurple.withOpacity(0.6), width: 1.5),
                boxShadow: [BoxShadow(color: _accentPurple.withOpacity(0.1), blurRadius: 12)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: brand['color'].withOpacity(0.2),
                      border: Border.all(color: brand['color'].withOpacity(0.3), width: 1),
                    ),
                    child: Icon(brand['icon'], color: brand['color'], size: 30),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        brand['title'],
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAmountChip('5', brand['color']),
                      const SizedBox(width: 8),
                      _buildAmountChip('10', brand['color']),
                      const SizedBox(width: 8),
                      _buildAmountChip('20', brand['color']),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmountChip(String amount, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: Text(
        '\$$amount',
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ==========================================================================
  // Redeem Bottom Sheet
  // ==========================================================================
  void _showRedeemBottomSheet({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
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
              const SizedBox(height: 24),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.15),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Icon(icon, color: color, size: 48),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Redeem $title Card',
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Select an amount to redeem directly from your wallet.',
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRedeemAmountButton('5', color),
                  _buildRedeemAmountButton('10', color),
                  _buildRedeemAmountButton('20', color),
                ],
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Cancel', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRedeemAmountButton(String amount, Color color) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.15),
          foregroundColor: color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: color.withOpacity(0.4)),
          ),
        ),
        child: Text(
          '\$$amount',
          style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ==========================================================================
  // All Cards Bottom Sheet
  // ==========================================================================
  void _showAllCardsBottomSheet() {
    final List<Map<String, dynamic>> brands = [
      {'title': 'Amazon', 'icon': Icons.shopping_bag_outlined, 'color': const Color(0xFFFF9900)},
      {'title': 'Apple', 'icon': Icons.apple, 'color': Colors.grey},
      {'title': 'Steam', 'icon': Icons.gamepad, 'color': const Color(0xFF171A21)},
      {'title': 'Google Play', 'icon': Icons.android, 'color': const Color(0xFF34A853)},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
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
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'All Gift Cards',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _showRedeemBottomSheet(
                          title: brand['title'],
                          icon: brand['icon'],
                          color: brand['color'],
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14141E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _accentPurple.withOpacity(0.4), width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(brand['icon'], color: brand['color'], size: 40),
                            const SizedBox(height: 12),
                            Text(
                              brand['title'],
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================================
  // Recent Activity
  // ==========================================================================
  Widget _buildCompactHistory() {
    final List<Map<String, dynamic>> history = [
      {
        'title': 'Amazon \$10 Card',
        'amount': '- 10.00 USDT',
        'date': 'Today, 10:30 AM',
        'color': const Color(0xFFFF9900),
        'isOut': true,
      },
      {
        'title': 'USDT Withdrawal',
        'amount': '- 20.00 USDT',
        'date': 'Yesterday, 4:15 PM',
        'color': _accentGold,
        'isOut': true,
      },
      {
        'title': 'Daily Steps Bonus',
        'amount': '+ 1.50 USDT',
        'date': 'Yesterday, 9:30 AM',
        'color': _accentPink,
        'isOut': false,
      },
      {
        'title': 'Referral Bonus',
        'amount': '+ 5.00 USDT',
        'date': '2 days ago',
        'color': _accentPurple,
        'isOut': false,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14141E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: history.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item['color'].withOpacity(0.1),
                    border: Border.all(color: item['color'].withOpacity(0.2)),
                  ),
                  child: Icon(
                    item['isOut'] ? Icons.arrow_upward : Icons.arrow_downward,
                    color: item['color'],
                    size: 16,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item['date'],
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  item['amount'],
                  style: TextStyle(
                    color: item['isOut'] ? Colors.white60 : item['color'],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}