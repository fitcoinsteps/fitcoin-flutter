// lib/features/spin_screen/spin_screen.dart
import 'dart:async';
import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ============================================================
// 1. تعريف SpinItem
// ============================================================
class SpinItem {
  String label;
  TextStyle labelStyle;
  Color color;

  SpinItem({
    required this.label,
    required this.color,
    required this.labelStyle,
  });
}

// ============================================================
// 2. تعريف SpinWheelPainter (رسم العجلة)
// ============================================================
class SpinWheelPainter extends CustomPainter {
  final List<SpinItem> items;

  SpinWheelPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final paint = Paint()..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10.0);

    const spaceBetweenItems = 0.05;
    final totalSections = items.length;
    const totalAngle = 2 * math.pi;
    final sectionAngleWithSpace =
        (totalAngle - (totalSections * spaceBetweenItems)) / totalSections;
    const spaceOnBothSides = spaceBetweenItems / 2;

    for (var i = 0; i < items.length; i++) {
      final startAngle =
          i * (sectionAngleWithSpace + spaceBetweenItems) + spaceOnBothSides;

      paint.color = items[i].color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectionAngleWithSpace,
        true,
        shadowPaint,
      );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectionAngleWithSpace,
        true,
        paint,
      );
    }

    final centerCircleRadius = radius * 0.05;
    final centerCirclePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, centerCircleRadius, centerCirclePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ============================================================
// 3. تعريف MySpinController (التحكم بالعجلة)
// ============================================================
class MySpinController {
  late AnimationController _baseAnimation;
  late TickerProvider _tickerProvider;
  bool _xSpinning = false;
  List<SpinItem> _itemList = [];

  Future<void> initLoad({
    required TickerProvider tickerProvider,
    required List<SpinItem> itemList,
  }) async {
    _tickerProvider = tickerProvider;
    _itemList = itemList;
    await setAnimations(_tickerProvider);
  }

  Future<void> setAnimations(TickerProvider tickerProvider) async {
    _baseAnimation = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 200),
    );
  }

  void dispose() {
    _baseAnimation.dispose();
  }

  Future<void> spinNow({
    required int luckyIndex,
    int totalSpin = 10,
    int baseSpinDuration = 100,
  }) async {
    int itemsLength = _itemList.length;
    int factor = luckyIndex % itemsLength;
    if (factor == 0) factor = itemsLength;
    double spinInterval = 1 / itemsLength;
    double target = 1 - ((spinInterval * factor) - (spinInterval / 2));

    if (!_xSpinning) {
      _xSpinning = true;
      int spinCount = 0;

      do {
        _baseAnimation.reset();
        _baseAnimation.duration = Duration(milliseconds: baseSpinDuration);
        if (spinCount == totalSpin) {
          await _baseAnimation.animateTo(target);
        } else {
          await _baseAnimation.forward();
        }
        baseSpinDuration = baseSpinDuration + 50;
        _baseAnimation.duration = Duration(milliseconds: baseSpinDuration);
        spinCount++;
      } while (spinCount <= totalSpin);

      _xSpinning = false;
    }
  }
}

// ============================================================
// 4. تعريف MySpinner (عجلة الحظ)
// ============================================================
class MySpinner extends StatefulWidget {
  final MySpinController mySpinController;
  final List<SpinItem> itemList;
  final double wheelSize;
  final Function(void) onFinished;

  const MySpinner({
    Key? key,
    required this.mySpinController,
    required this.onFinished,
    required this.itemList,
    required this.wheelSize,
  }) : super(key: key);

  @override
  State<MySpinner> createState() => _MySpinnerState();
}

class _MySpinnerState extends State<MySpinner> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.mySpinController.initLoad(
      tickerProvider: this,
      itemList: widget.itemList,
    );
  }

  @override
  void dispose() {
    widget.mySpinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15),
          alignment: Alignment.center,
          child: AnimatedBuilder(
            animation: widget.mySpinController._baseAnimation,
            builder: (context, child) {
              double value = widget.mySpinController._baseAnimation.value;
              double rotationValue = (360 * value);
              return RotationTransition(
                turns: AlwaysStoppedAnimation(rotationValue / 360),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: Container(
                        width: widget.wheelSize,
                        height: widget.wheelSize,
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.white,
                              Colors.black,
                              Colors.white,
                              Colors.black
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(5),
                          child: CustomPaint(
                            painter: SpinWheelPainter(
                              items: widget.itemList,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ...widget.itemList.map((each) {
                      int index = widget.itemList.indexOf(each);
                      double rotateInterval = 360 / widget.itemList.length;
                      double rotateAmount = (index + 0.5) * rotateInterval;
                      return RotationTransition(
                        turns: AlwaysStoppedAnimation(rotateAmount / 360),
                        child: Transform.translate(
                          offset: Offset(0, -widget.wheelSize / 4),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              each.label,
                              style: each.labelStyle,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    Container(
                      alignment: Alignment.center,
                      width: 25,
                      height: 25,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(0),
          child: const Icon(
            Icons.location_on_sharp,
            size: 50,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 5. صفحة SpinScreen الرئيسية
// ============================================================
class SpinScreen extends ConsumerStatefulWidget {
  const SpinScreen({super.key});

  @override
  ConsumerState<SpinScreen> createState() => _SpinScreenState();
}

class _SpinScreenState extends ConsumerState<SpinScreen> {
  final MySpinController _spinController = MySpinController();
  final StreamController<int> _selectedController = StreamController<int>();
  bool _isSpinning = false;
  String _resultMessage = '';
  Color _resultColor = Colors.white;

  // الألوان
  final Color _neonPink = const Color(0xFFD946EF);
  final Color _neonPurple = const Color(0xFF8B5CF6);
  final Color _neonGold = const Color(0xFFFFD93D);
  final Color _neonBlue = const Color(0xFF1E90FF);
  final Color _neonOrange = const Color(0xFFFF9900);
  final Color _neonGreen = const Color(0xFF00E676);

  // قائمة عناصر العجلة
  final List<SpinItem> _spinItems = [
    SpinItem(
      label: '0%',
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      color: const Color(0xFF2D2D2D),
    ),
    SpinItem(
      label: '5%',
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      color: const Color(0xFF9E00FF),
    ),
    SpinItem(
      label: '10%',
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      color: const Color(0xFF00A0FF),
    ),
    SpinItem(
      label: '15%',
      labelStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      color: const Color(0xFFFFE000),
    ),
    SpinItem(
      label: '20%',
      labelStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      color: Colors.white,
    ),
    SpinItem(
      label: '25%',
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      color: const Color(0xFFDE0000),
    ),
    SpinItem(
      label: '30%',
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      color: const Color(0xFF41D849),
    ),
    SpinItem(
      label: '35%',
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      color: const Color(0xFFFF9C00),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedController.stream.listen((index) {
      if (mounted) {
        setState(() {
          final item = _spinItems[index];
          _resultMessage = '🎉 You won ${item.label} discount!';
          _resultColor = item.color;
        });
      }
    });
  }

  @override
  void dispose() {
    _selectedController.close();
    _spinController.dispose();
    super.dispose();
  }

  Future<void> _spinWheel() async {
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
      _resultMessage = '';
    });

    final int luckyIndex = Random().nextInt(_spinItems.length);

    await _spinController.spinNow(
      luckyIndex: luckyIndex + 1,
      totalSpin: 10,
      baseSpinDuration: 20,
    );

    _selectedController.add(luckyIndex);

    if (mounted) {
      setState(() {
        _isSpinning = false;
      });
    }
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildTitle(),
                    const SizedBox(height: 20),
                    _buildSpinnerWheel(),
                    const SizedBox(height: 20),
                    if (_resultMessage.isNotEmpty) _buildResultMessage(),
                    const SizedBox(height: 16),
                    _buildSpinButton(),
                    const SizedBox(height: 20),
                    _buildSpinInfo(),
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
            'Lucky Spin',
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
                colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_spinItems.length} Prizes',
                  style: const TextStyle(
                    color: Colors.white,
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
          '🎰 Spin & Win',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Try your luck and win amazing discounts!',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSpinnerWheel() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                _neonPurple.withOpacity(0.3),
                _neonPink.withOpacity(0.1),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        MySpinner(
          mySpinController: _spinController,
          wheelSize: MediaQuery.of(context).size.width * 0.75,
          itemList: _spinItems,
          onFinished: (p0) {},
        ),
        Positioned(
          top: 0,
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_drop_up,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _neonPurple.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.star,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _resultColor.withOpacity(0.2),
            _resultColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _resultColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _resultColor.withOpacity(0.2),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.amber,
            size: 24,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              _resultMessage,
              style: TextStyle(
                color: _resultColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpinButton() {
    return ElevatedButton(
      onPressed: _isSpinning ? null : _spinWheel,
      style: ElevatedButton.styleFrom(
        backgroundColor: _neonGold,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        shadowColor: _neonGold.withOpacity(0.4),
        disabledBackgroundColor: Colors.grey.shade700,
      ),
      child: _isSpinning
          ? const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: Colors.black,
        ),
      )
          : const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.casino_outlined, size: 24),
          SizedBox(width: 12),
          Text(
            'SPIN NOW',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpinInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            icon: Icons.timer_outlined,
            label: 'Free Spin',
            value: '1/Day',
            color: _neonBlue,
          ),
          Container(
            width: 1,
            height: 30,
            color: Colors.white.withOpacity(0.1),
          ),
          _buildInfoItem(
            icon: Icons.stars_outlined,
            label: 'Min Win',
            value: '0%',
            color: _neonGreen,
          ),
          Container(
            width: 1,
            height: 30,
            color: Colors.white.withOpacity(0.1),
          ),
          _buildInfoItem(
            icon: Icons.emoji_events_outlined,
            label: 'Max Win',
            value: '35%',
            color: _neonGold,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}