// lib/features/earnings/presentation/screens/earnings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fitcoin/core/theme/app_colors.dart';
import 'package:fitcoin/core/theme/widgets/global_app_bar.dart';
import 'package:fitcoin/core/theme/widgets/starfield_background.dart';

// Fitcoin balance
import 'package:fitcoin/features/fitcoin/presentation/providers/fitcoin_providers.dart';
import 'package:fitcoin/features/fitcoin/presentation/states/fitcoin_states.dart';

// Step counter
import 'package:fitcoin/features/step_counter/presentation/providers/step_providers.dart';
import 'package:fitcoin/features/step_counter/presentation/states/step_states.dart';

// Login state
import 'package:fitcoin/features/login_auth/presentation/providers/login_providers.dart';
import 'package:fitcoin/features/login_auth/presentation/states/login_states.dart';

class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  final Color _neonPink = const Color(0xFFD946EF);
  final Color _neonPurple = const Color(0xFF8B5CF6);
  final Color _neonGold = const Color(0xFFFFD93D);
  final Color _neonBlue = const Color(0xFF1E90FF);
  final Color _neonOrange = const Color(0xFFFF9900);
  final Color _neonGreen = const Color(0xFF00E676);

  // عداد دعوة الأصدقاء (يمكن تغييره للتجربة)
  int _invitedCount = 7;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      try {
        ref.read(stepControllerProvider.notifier).init();
        ref.read(fitcoinControllerProvider.notifier).loadBalance();
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final fitcoinState = ref.watch(fitcoinControllerProvider);
    final stepState = ref.watch(stepControllerProvider);
    final loginState = ref.watch(loginProvider);

    String fullName = 'User';
    if (loginState is LoginSuccess) {
      final user = loginState.response.user;
      final first = user.firstName.trim();
      final last = user.lastName.trim();
      final combined = '$first $last'.trim();
      fullName = combined.isNotEmpty ? combined : user.username;
    }

    return StarfieldBackground(
      child: Column(
        children: [
          // ========== 1. شريط العنوان ==========
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
              const SizedBox(width: 12),
              const Icon(Icons.notifications_none, color: Colors.white, size: 24),
            ],
          ),

          // ========== 2. محتوى الصفحة ==========
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),

                  // ----- القسم 1: الإعلانات والعروض -----
                  _buildSectionTitle('Ads & Offers'),
                  const SizedBox(height: 12),
                  _buildAdsOffersSection(),

                  const SizedBox(height: 28),

                  // ----- القسم 2: المهام الاجتماعية -----
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Social & Rewards'),
                      InkWell(
                        onTap: () => _showSocialBottomSheet(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _neonPink.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _neonPink.withOpacity(0.3)),
                          ),
                          child: Text(
                            'View All',
                            style: TextStyle(color: _neonPink, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSocialMethods(),

                  const SizedBox(height: 28),

                  // ----- القسم 3: المهام اليومية (تظهر فوق بعض) -----
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Daily Tasks'),
                      InkWell(
                        onTap: () => _showDailyTasksBottomSheet(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _neonPurple.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _neonPurple.withOpacity(0.3)),
                          ),
                          child: Text(
                            'View All',
                            style: TextStyle(color: _neonPurple, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildDailyTasks(),

                  const SizedBox(height: 28),

                  // ----- القسم 4: دعوة الأصدقاء (مع زر Claim) -----
                  _buildSectionTitle('Invite & Earn'),
                  const SizedBox(height: 12),
                  _buildInviteSection(),

                  const SizedBox(height: 28),

                  // ----- القسم 5: سجل الأرباح -----
                  _buildSectionTitle('Recent Earnings'),
                  const SizedBox(height: 12),
                  _buildRecentEarningsList(),

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
  // دالة مساعدة لعناوين الأقسام (مع تدرج لوني)
  // ==========================================================================
  Widget _buildSectionTitle(String title) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [Colors.white, Color(0xFFD946EF)],
        ).createShader(bounds);
      },
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ==========================================================================
  // القسم 1: الإعلانات والعروض (تصميم زجاجي فاخر)
  // ==========================================================================
  Widget _buildAdsOffersSection() {
    return Column(
      children: [
        // بطاقة مشاهدة 3 إعلانات
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0D28).withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _neonBlue.withOpacity(0.4), width: 1.5),
            boxShadow: [BoxShadow(color: _neonBlue.withOpacity(0.15), blurRadius: 20, spreadRadius: 2)],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _neonBlue.withOpacity(0.15),
                  border: Border.all(color: _neonBlue.withOpacity(0.2)),
                ),
                child: Icon(Icons.play_circle_outline, color: _neonBlue, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Watch 3 Ads', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    Text('Earn up to 50 FIT daily', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _showWatchAdsBottomSheet(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF1E90FF), Color(0xFF00BFFF)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: _neonBlue.withOpacity(0.3), blurRadius: 10)],
                  ),
                  child: const Text('Watch Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // بطاقة مشاهدة 3 فيديوهات
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0D28).withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _neonOrange.withOpacity(0.4), width: 1.5),
            boxShadow: [BoxShadow(color: _neonOrange.withOpacity(0.15), blurRadius: 20, spreadRadius: 2)],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _neonOrange.withOpacity(0.15),
                  border: Border.all(color: _neonOrange.withOpacity(0.2)),
                ),
                child: Icon(Icons.ondemand_video, color: _neonOrange, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Watch 3 Videos', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    Text('Earn up to 60 FIT daily', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _showWatchVideosBottomSheet(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.orange, Color(0xFFFF9900)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: _neonOrange.withOpacity(0.3), blurRadius: 10)],
                  ),
                  child: const Text('Watch Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // بطاقة التقييم (Rate Us)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0D28).withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _neonGold.withOpacity(0.6), width: 2),
            boxShadow: [
              BoxShadow(color: _neonGold.withOpacity(0.3), blurRadius: 30, spreadRadius: 5),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [Color(0xFFFFD93D), Colors.orange]),
                  boxShadow: [BoxShadow(color: _neonGold.withOpacity(0.4), blurRadius: 15)],
                ),
                child: const Icon(Icons.star_rate_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rate us on the Store!', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    Text('Give a 5-star review and earn 50 FIT instantly!', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => context.push('/rate-app'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _neonGold,
                  foregroundColor: Colors.black,
                  elevation: 8,
                  shadowColor: _neonGold,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                child: const Text('Rate Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // نافذة مشاهدة الإعلانات
  // ==========================================================================
  void _showWatchAdsBottomSheet(BuildContext context) {
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
                  'Watch Ads & Earn',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: index == 0 ? _neonBlue : Colors.white24, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          index == 0 ? 'Ad 1 (Watched)' : 'Ad ${index + 1} (Pending)',
                          style: TextStyle(color: index == 0 ? Colors.white : Colors.white38, fontSize: 14),
                        ),
                        const Spacer(),
                        if (index == 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.withOpacity(0.2)),
                            ),
                            child: const Text('+ 15 FIT', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF1E90FF), Color(0xFF00BFFF)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Watch Next Ad',
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
  // نافذة مشاهدة الفيديوهات
  // ==========================================================================
  void _showWatchVideosBottomSheet(BuildContext context) {
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
                  'Watch Videos & Earn',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Watch 3 videos daily to earn 60 FIT',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),

              ...List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: index == 0 ? _neonOrange : Colors.white24, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          index == 0 ? 'Video 1 (Watched)' : 'Video ${index + 1} (Pending)',
                          style: TextStyle(color: index == 0 ? Colors.white : Colors.white38, fontSize: 14),
                        ),
                        const Spacer(),
                        if (index == 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.withOpacity(0.2)),
                            ),
                            child: const Text('+ 20 FIT', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.orange, Color(0xFFFF9900)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'Watch Next Video',
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
  // القسم 2: المهام الاجتماعية (المعرض الرئيسي)
  // ==========================================================================
  Widget _buildSocialMethods() {
    final List<Map<String, dynamic>> methods = [
      {'title': 'Follow Instagram', 'icon': Icons.camera_alt_outlined, 'color': const Color(0xFFE1306C), 'reward': '100 FIT'},
      {'title': 'Follow Facebook', 'icon': Icons.facebook, 'color': const Color(0xFF1877F2), 'reward': '100 FIT'},
      {'title': 'Follow TikTok', 'icon': Icons.music_note, 'color': Colors.black, 'reward': '100 FIT'},
    ];

    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: methods.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          final method = methods[index];
          final screenWidth = MediaQuery.of(context).size.width;
          final cardWidth = (screenWidth - 48) / 2.0;

          return Container(
            width: cardWidth,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A0D28).withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: method['color'].withOpacity(0.4), width: 1),
              boxShadow: [BoxShadow(color: method['color'].withOpacity(0.1), blurRadius: 20)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: method['color'].withOpacity(0.15),
                  ),
                  child: Icon(method['icon'], color: method['color'], size: 26),
                ),
                const SizedBox(height: 8),
                Text(method['title'], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(method['reward'], style: TextStyle(color: method['color'], fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==========================================================================
  // نافذة جميع مهام السوشال ميديا (View All)
  // ==========================================================================
  void _showSocialBottomSheet(BuildContext context) {
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
                  'Social Tasks',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Follow Pages',
                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ..._getFollowTasks().map((task) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: task['color'].withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: task['color'].withOpacity(0.15),
                        ),
                        child: Icon(task['icon'], color: task['color'], size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task['title'], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                            Text(task['reward'], style: TextStyle(color: task['color'], fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: task['color'].withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Follow', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                );
              }).toList(),

              const SizedBox(height: 16),

              const Text(
                'Watch Content',
                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ..._getWatchTasks().map((task) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: task['color'].withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: task['color'].withOpacity(0.15),
                        ),
                        child: Icon(task['icon'], color: task['color'], size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task['title'], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                            Text(task['reward'], style: TextStyle(color: task['color'], fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: task['color'].withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Watch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================================
  // بيانات المهام الاجتماعية
  // ==========================================================================
  List<Map<String, dynamic>> _getFollowTasks() {
    return [
      {'title': 'Follow Instagram', 'icon': Icons.camera_alt_outlined, 'color': const Color(0xFFE1306C), 'reward': '+ 100 FIT'},
      {'title': 'Follow Facebook', 'icon': Icons.facebook, 'color': const Color(0xFF1877F2), 'reward': '+ 100 FIT'},
      {'title': 'Follow TikTok', 'icon': Icons.music_note, 'color': Colors.black, 'reward': '+ 100 FIT'},
    ];
  }

  List<Map<String, dynamic>> _getWatchTasks() {
    return [
      {'title': 'Watch Instagram Reels', 'icon': Icons.ondemand_video, 'color': const Color(0xFFE1306C), 'reward': '+ 50 FIT'},
      {'title': 'Watch Facebook Videos', 'icon': Icons.play_arrow, 'color': const Color(0xFF1877F2), 'reward': '+ 50 FIT'},
      {'title': 'Watch TikTok Videos', 'icon': Icons.music_video, 'color': Colors.black, 'reward': '+ 50 FIT'},
    ];
  }

  // ==========================================================================
  // القسم 3: المهام اليومية (تظهر فوق بعض)
  // ==========================================================================
  Widget _buildDailyTasks() {
    final List<Map<String, dynamic>> tasks = [
      {'title': 'Watch', 'icon': Icons.ondemand_video, 'color': _neonOrange, 'reward': '50 FIT'},
      {'title': 'Scratch', 'icon': Icons.credit_card, 'color': _neonPurple, 'reward': 'Reward'},
      {'title': 'Spin', 'icon': Icons.casino_outlined, 'color': _neonPink, 'reward': 'Free Spin'},
      {'title': 'Quiz', 'icon': Icons.quiz_outlined, 'color': _neonGreen, 'reward': '100 FIT'},
    ];

    return Column(
      children: tasks.map((task) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0D28).withOpacity(0.6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: task['color'].withOpacity(0.4), width: 1),
            boxShadow: [BoxShadow(color: task['color'].withOpacity(0.1), blurRadius: 15)],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task['color'].withOpacity(0.15),
                ),
                child: Icon(task['icon'], color: task['color'], size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task['title'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    Text(task['reward'], style: TextStyle(color: task['color'], fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: task['color'].withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('Start', style: TextStyle(color: task['color'], fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ==========================================================================
  // نافذة جميع المهام اليومية (View All)
  // ==========================================================================
  void _showDailyTasksBottomSheet(BuildContext context) {
    final List<Map<String, dynamic>> tasks = [
      {'title': 'Watch', 'icon': Icons.ondemand_video, 'color': _neonOrange, 'reward': '50 FIT'},
      {'title': 'Scratch', 'icon': Icons.credit_card, 'color': _neonPurple, 'reward': 'Reward'},
      {'title': 'Spin', 'icon': Icons.casino_outlined, 'color': _neonPink, 'reward': 'Free Spin'},
      {'title': 'Quiz', 'icon': Icons.quiz_outlined, 'color': _neonGreen, 'reward': '100 FIT'},
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
                  'All Daily Tasks',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              ...tasks.map((task) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: task['color'].withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: task['color'].withOpacity(0.15),
                        ),
                        child: Icon(task['icon'], color: task['color'], size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task['title'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                            Text(task['reward'], style: TextStyle(color: task['color'], fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: task['color'].withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('Start', style: TextStyle(color: task['color'], fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================================
  // القسم 4: دعوة الأصدقاء (مع زر Claim)
  // ==========================================================================
  Widget _buildInviteSection() {
    final List<Map<String, dynamic>> levels = [
      {'count': 10, 'reward': '50 FIT'},
      {'count': 25, 'reward': '100 FIT'},
      {'count': 50, 'reward': '200 FIT'},
      {'count': 100, 'reward': '500 FIT'},
      {'count': 200, 'reward': '750 FIT'},
      {'count': 500, 'reward': '1000 FIT'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0D28).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _neonGold.withOpacity(0.6), width: 1.5),
        boxShadow: [BoxShadow(color: _neonGold.withOpacity(0.2), blurRadius: 20, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _neonGold.withOpacity(0.15),
                  border: Border.all(color: _neonGold.withOpacity(0.2)),
                ),
                child: Icon(Icons.people, color: _neonGold, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Invite & Earn',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)]),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: const Color(0xFFD946EF).withOpacity(0.4), blurRadius: 12)],
                ),
                child: InkWell(
                  onTap: () => context.push('/refer'),
                  child: const Text('Invite Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Your Invite Code:', style: TextStyle(color: Colors.white70, fontSize: 13)),
                Row(
                  children: [
                    Text(
                      'FIT-12345',
                      style: TextStyle(color: _neonGold, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.copy, color: Colors.white70, size: 16),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('You have invited $_invitedCount friends', style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),

          ...levels.map((level) {
            final int count = level['count'];
            final bool isCompleted = _invitedCount >= count;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: isCompleted ? _neonGold.withOpacity(0.15) : Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCompleted ? _neonGold.withOpacity(0.6) : Colors.white.withOpacity(0.08),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Invite $count friends', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Row(
                    children: [
                      Text(level['reward'], style: TextStyle(color: _neonGold, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: _neonGold,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('Claim', style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
                        )
                      else
                        Text('$_invitedCount / $count', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // ==========================================================================
  // القسم 5: سجل الأرباح
  // ==========================================================================
  Widget _buildRecentEarningsList() {
    final List<Map<String, dynamic>> history = [
      {'title': 'Daily Steps Goal', 'amount': '+ 150 FIT', 'date': 'Today', 'color': _neonPink},
      {'title': 'Invited a Friend', 'amount': '+ 50 FIT', 'date': 'Today', 'color': _neonGold},
      {'title': 'Watched an Ad', 'amount': '+ 50 FIT', 'date': 'Yesterday', 'color': _neonBlue},
      {'title': 'Completed Challenge', 'amount': '+ 300 FIT', 'date': '2 days ago', 'color': _neonPurple},
    ];

    return Column(
      children: history.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0D28).withOpacity(0.6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
            boxShadow: [BoxShadow(color: item['color'].withOpacity(0.1), blurRadius: 15)],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item['color'].withOpacity(0.15),
                ),
                child: Icon(item['amount'].startsWith('+') ? Icons.arrow_downward : Icons.arrow_upward, color: item['color'], size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    Text(item['date'], style: const TextStyle(fontSize: 11, color: Colors.white70)),
                  ],
                ),
              ),
              Text(item['amount'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: item['color'])),
            ],
          ),
        );
      }).toList(),
    );
  }
}