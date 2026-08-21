// lib/features/scratch_card_screen/scratch_card_screen.dart
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_scratch_card/flutter_scratch_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScratchCardScreen extends ConsumerStatefulWidget {
  const ScratchCardScreen({super.key});

  @override
  ConsumerState<ScratchCardScreen> createState() => _ScratchCardScreenState();
}

class _ScratchCardScreenState extends ConsumerState<ScratchCardScreen> {
  late ScratchController _controller;
  String _revealedPrize = '';
  bool _isRevealed = false;
  double _progress = 0.0;
  String _statusMessage = 'Scratch to reveal your prize!';

  // ✅ عدد المحاولات
  int _attemptsLeft = 3;
  int _maxAttempts = 3;
  String _lastAttemptDate = '';

  // ✅ الألوان
  final Color _neonPink = const Color(0xFFD946EF);
  final Color _neonPurple = const Color(0xFF8B5CF6);
  final Color _neonGold = const Color(0xFFFFD93D);
  final Color _neonBlue = const Color(0xFF1E90FF);
  final Color _neonOrange = const Color(0xFFFF9900);
  final Color _neonGreen = const Color(0xFF00E676);

  // ✅ قائمة الجوائز
  final List<Map<String, dynamic>> _prizes = [
    {'label': '🎉 50 FIT', 'color': const Color(0xFFFFD93D)},
    {'label': '🎊 100 FIT', 'color': const Color(0xFF00E676)},
    {'label': '⭐ 25 FIT', 'color': const Color(0xFF1E90FF)},
    {'label': '🏆 200 FIT', 'color': const Color(0xFF8B5CF6)},
    {'label': '💎 500 FIT', 'color': const Color(0xFFD946EF)},
    {'label': '🎁 Free Spin', 'color': const Color(0xFFFF9900)},
  ];

  String _selectedPrize = '';

  @override
  void initState() {
    super.initState();
    _controller = ScratchController();
    _loadAttempts();
    _selectRandomPrize();
  }

  // ✅ تحميل عدد المحاولات من التخزين المحلي
  Future<void> _loadAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T').first;
    final savedDate = prefs.getString('scratch_date') ?? '';
    final savedAttempts = prefs.getInt('scratch_attempts') ?? 3;

    setState(() {
      if (savedDate != today) {
        // ✅ يوم جديد - إعادة تعيين المحاولات
        _attemptsLeft = 3;
        _lastAttemptDate = today;
        prefs.setString('scratch_date', today);
        prefs.setInt('scratch_attempts', 3);
      } else {
        _attemptsLeft = savedAttempts;
        _lastAttemptDate = savedDate;
      }
    });
  }

  // ✅ حفظ عدد المحاولات
  Future<void> _saveAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T').first;
    await prefs.setString('scratch_date', today);
    await prefs.setInt('scratch_attempts', _attemptsLeft);
  }

  void _selectRandomPrize() {
    final random = Random();
    final index = random.nextInt(_prizes.length);
    _selectedPrize = _prizes[index]['label'] as String;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleComplete() {
    setState(() {
      _isRevealed = true;
      _revealedPrize = _selectedPrize;
      _statusMessage = '🎉 Congratulations! You won $_selectedPrize!';
    });
  }

  void _handleProgress(double progress) {
    setState(() {
      _progress = progress;
    });
  }

  void _handleMilestone(double milestone) {
    // يمكن استخدامها للتأثيرات
  }

  // ✅ زر Spin Again
  void _spinAgain() {
    if (_attemptsLeft <= 0) {
      setState(() {
        _statusMessage = '⛔ No attempts left! Come back tomorrow.';
      });
      return;
    }

    setState(() {
      _isRevealed = false;
      _revealedPrize = '';
      _progress = 0.0;
      _attemptsLeft--;
      _statusMessage = 'Scratch to reveal your prize! (${_attemptsLeft} attempts left)';
      _selectRandomPrize();
      _saveAttempts();
    });
    _controller.reset(animated: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1B3A),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    // ✅ دائرة اللوغو في الأعلى
                    _buildLogoCircle(),
                    const SizedBox(height: 20),
                    _buildTitle(),
                    const SizedBox(height: 20),
                    _buildScratchCard(),
                    const SizedBox(height: 20),
                    _buildStatusSection(),
                    const SizedBox(height: 16),
                    // ✅ عدد المحاولات بدلاً من شريط التقدم
                    _buildAttemptsCounter(),
                    const SizedBox(height: 20),
                    // ✅ زر واحد فقط "Spin Again"
                    _buildSpinButton(),
                    const SizedBox(height: 20),
                    _buildPrizeHistory(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ دائرة اللوغو في الأعلى
  Widget _buildLogoCircle() {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/logo.png', // ✅ ضع مسار اللوغو الخاص بك هنا
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // ✅ لوغو افتراضي في حال عدم وجود الصورة
              return Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.pop(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Scratch Card',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD93D), Color(0xFFFF9900)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.black,
                  size: 14,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Win Prizes',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Column(
      children: [
        Text(
          '🎰 Scratch & Win',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Scratch the card to reveal your prize!',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildScratchCard() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD93D).withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // الخلفية
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF8B5CF6).withOpacity(0.8),
                    const Color(0xFFD946EF).withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // بطاقة الخدش
            ScratchCard(
              controller: _controller,
              overlayImage: const AssetImage('assets/scratch_overlay.png'),
              fallbackOverlayImage: const AssetImage('assets/scratch_overlay.png'),
              theme: ScratchCardTheme.premium(),
              brush: ScratchBrush.soft(size: 35),
              revealShape: ScratchRevealShape.circle(),
              haptic: const ScratchHapticConfig(
                onScratch: HapticType.light,
                onMilestone: HapticType.medium,
                onComplete: HapticType.heavy,
              ),
              completion: const ScratchCompletionConfig(
                effect: ScratchCompletionEffect.confetti,
              ),
              animation: const ScratchAnimationConfig(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
              ),
              progressTriggers: const [0.25, 0.5, 0.75],
              onScratchStart: () {
                setState(() {
                  _statusMessage = 'Scratching...';
                });
              },
              onScratch: (offset) {},
              onScratchEnd: () {
                setState(() {
                  if (!_isRevealed) {
                    _statusMessage = 'Keep scratching!';
                  }
                });
              },
              onProgress: _handleProgress,
              onMilestone: _handleMilestone,
              onThreshold: () {
                setState(() {
                  _statusMessage = '🎯 Threshold reached!';
                });
              },
              onComplete: _handleComplete,
              onReset: () {
                setState(() {
                  _statusMessage = 'Card reset! Scratch again!';
                });
              },
              semanticLabel: 'Scratch card containing a prize',
              semanticHint: 'Scratch to reveal your reward',
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.amber,
                        size: 50,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _isRevealed ? _revealedPrize : '🎁 ???',
                        style: TextStyle(
                          color: _isRevealed ? const Color(0xFFFFD93D) : Colors.white70,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_isRevealed) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD93D).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFFD93D).withOpacity(0.3),
                            ),
                          ),
                          child: const Text(
                            '🎉 You Won!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            // مؤشر التقدم
            if (_isRevealed)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Revealed!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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

  Widget _buildStatusSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0D28).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFD93D).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFD93D).withOpacity(0.15),
            ),
            child: Icon(
              _isRevealed ? Icons.emoji_events : Icons.info_outline,
              color: _isRevealed ? const Color(0xFFFFD93D) : Colors.white54,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _statusMessage,
              style: TextStyle(
                color: _isRevealed ? const Color(0xFFFFD93D) : Colors.white70,
                fontSize: 14,
                fontWeight: _isRevealed ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ عداد المحاولات
  Widget _buildAttemptsCounter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0D28).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFD93D).withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '🎯 Attempts Today',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: List.generate(_maxAttempts, (index) {
              final isUsed = index >= _attemptsLeft;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isUsed
                        ? Colors.grey.withOpacity(0.3)
                        : const Color(0xFFFFD93D).withOpacity(0.3),
                    border: Border.all(
                      color: isUsed
                          ? Colors.grey.withOpacity(0.3)
                          : const Color(0xFFFFD93D),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isUsed ? Icons.close : Icons.check,
                      color: isUsed ? Colors.grey : const Color(0xFFFFD93D),
                      size: 16,
                    ),
                  ),
                ),
              );
            }),
          ),
          Text(
            '$_attemptsLeft / $_maxAttempts',
            style: TextStyle(
              color: _attemptsLeft > 0 ? const Color(0xFFFFD93D) : Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ زر واحد فقط "Spin Again"
  Widget _buildSpinButton() {
    final bool hasAttempts = _attemptsLeft > 0;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: hasAttempts ? _spinAgain : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: hasAttempts ? const Color(0xFFFFD93D) : Colors.grey.shade700,
          foregroundColor: hasAttempts ? Colors.black : Colors.white54,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: hasAttempts ? 8 : 0,
          shadowColor: hasAttempts ? const Color(0xFFFFD93D).withOpacity(0.4) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasAttempts ? Icons.refresh : Icons.block,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              hasAttempts
                  ? 'SPIN AGAIN (${_attemptsLeft} left)'
                  : 'NO ATTEMPTS LEFT',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrizeHistory() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0D28).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎯 Available Prizes',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _prizes.map((prize) {
              final isSelected = prize['label'] == _selectedPrize;
              final color = prize['color'] as Color;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : color.withOpacity(0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 14,
                      ),
                    if (isSelected) const SizedBox(width: 4),
                    Text(
                      prize['label'] as String,
                      style: TextStyle(
                        color: isSelected ? color : Colors.white70,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}