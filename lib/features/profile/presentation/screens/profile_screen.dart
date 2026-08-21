// lib/features/profile/presentation/screens/profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitcoin/core/theme/app_colors.dart';
import 'package:fitcoin/core/theme/widgets/global_app_bar.dart';
import 'package:fitcoin/core/theme/widgets/starfield_background.dart';

// Fitcoin balance
import 'package:fitcoin/features/fitcoin/presentation/providers/fitcoin_providers.dart';
import 'package:fitcoin/features/fitcoin/presentation/states/fitcoin_states.dart';

// Login state
import 'package:fitcoin/features/login_auth/presentation/providers/login_providers.dart';
import 'package:fitcoin/features/login_auth/presentation/states/login_states.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final Color _accentPink = const Color(0xFFD946EF);
  final Color _accentPurple = const Color(0xFF8B5CF6);
  final Color _accentGold = const Color(0xFFFFD93D);

  int _selectedSectionIndex = 0;

  // متغيرات الصورة الشخصية
  File? _profileImage;
  int _selectedAvatarIndex = 0; // 0 = حرف, 1 = صورة افتراضية ملونة

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(fitcoinControllerProvider.notifier).loadBalance();
    });
  }

  // ==========================================================================
  // دالة رفع الصورة
  // ==========================================================================
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
          _selectedAvatarIndex = -1; // -1 يعني صورة مرفوعة من الموبايل
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error accessing camera or gallery. Please check permissions.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ==========================================================================
  // قائمة تغيير الصورة (أيقونات Material)
  // ==========================================================================
  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF1A0D28),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text('Change Profile Picture', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAvatarOption(0, 'Default', Icons.person),
                  _buildAvatarOption(1, 'Avatar', Icons.face),
                  // زر رفع من المعرض
                  _buildPickerOption('Gallery', Icons.photo, ImageSource.gallery),
                  // زر رفع من الكاميرا
                  _buildPickerOption('Camera', Icons.camera_alt, ImageSource.camera),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickerOption(String label, IconData icon, ImageSource source) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _pickImage(source);
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAvatarOption(int index, String label, IconData icon) {
    final bool isSelected = _selectedAvatarIndex == index && _profileImage == null;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAvatarIndex = index;
          _profileImage = null;
        });
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index == 0 ? _accentPink.withOpacity(0.2) : Colors.transparent,
              border: Border.all(
                color: isSelected ? _accentPink : Colors.white.withOpacity(0.2),
                width: isSelected ? 3 : 1,
              ),
            ),
            child: Icon(icon, color: isSelected ? Colors.white : Colors.white60, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: isSelected ? _accentPink : Colors.white60, fontSize: 12)),
        ],
      ),
    );
  }

  // ==========================================================================
  // قائمة تعديل الملف الشخصي (Bottom Sheet)
  // ==========================================================================
  void _showEditProfileBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF1A0D28),
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
                child: Text('Edit Profile', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),

              // الاسم
              const Text('Full Name', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: 'Noor Al Kafre',
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
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
              const SizedBox(height: 16),

              // البريد الإلكتروني
              const Text('Email Address', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: 'noor@fitcoin.app',
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
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
              const SizedBox(height: 16),

              // كلمة المرور
              const Text('Change Password', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: '********',
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
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

              // زر الحفظ
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: const Color(0xFFD946EF).withOpacity(0.3), blurRadius: 10)],
                ),
                child: const Center(
                  child: Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fitcoinState = ref.watch(fitcoinControllerProvider);
    final loginState = ref.watch(loginProvider);

    String fullName = 'User';
    String email = 'user@fitcoin.app';
    if (loginState is LoginSuccess) {
      final user = loginState.response.user;
      final first = user.firstName.trim();
      final last = user.lastName.trim();
      final combined = '$first $last'.trim();
      fullName = combined.isNotEmpty ? combined : user.username;
      email = user.email;
    }

    final double fitcoinBalance = (fitcoinState.balance?.fitcoinBalance ?? 0).toDouble();

    return StarfieldBackground(
      child: Column(
        children: [
          // ========== 1. شريط العنوان ==========
          GlobalAppBar(
            leading: null,
            titleWidget: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            actions: [
              InkWell(
                onTap: () => context.push('/settings'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1A0D28),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const Icon(Icons.settings_outlined, color: Colors.white70, size: 22),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // ========== 2. المحتوى الرئيسي ==========
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),

                  // ----- القسم 1: بطاقة الملف الشخصي -----
                  _buildProfileCard(fullName, email, fitcoinBalance),

                  const SizedBox(height: 28),

                  // ----- القسم 2: شريط أزرار التنقل (Tabs) -----
                  _buildSectionTabs(),

                  const SizedBox(height: 28),

                  // ----- القسم 3: المحتوى الديناميكي -----
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: _buildDynamicContent(key: ValueKey(_selectedSectionIndex)),
                  ),

                  const SizedBox(height: 32),

                  // ----- القسم 4: زر تسجيل الخروج -----
                  _buildLogoutButton(),

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
  // القسم 1: بطاقة الملف الشخصي
  // ==========================================================================
  Widget _buildProfileCard(String name, String email, double balance) {
    // تحديد الصورة المعروضة
    Widget avatarWidget;
    if (_profileImage != null) {
      avatarWidget = ClipOval(
        child: Image.file(
          _profileImage!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      );
    } else if (_selectedAvatarIndex == 1) {
      avatarWidget = Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF8B5CF6),
        ),
        child: const Center(child: Icon(Icons.face, color: Colors.white, size: 40)),
      );
    } else {
      avatarWidget = Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
          boxShadow: [BoxShadow(color: _accentPink.withOpacity(0.3), blurRadius: 30)],
        ),
        child: Center(
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'U',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0D28).withOpacity(0.85), // زجاج داكن
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _accentPink.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _accentPink.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // صورة المستخدم مع أيقونة الكاميرا
          Stack(
            children: [
              avatarWidget,
              // أيقونة الكاميرا لتغيير الصورة
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    _showImagePickerOptions(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1A0D28),
                      border: Border.all(color: _accentPink.withOpacity(0.5), width: 2),
                    ),
                    child: const Icon(Icons.photo_camera, color: Colors.white70, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),

          // معلومات المستخدم
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _accentGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _accentGold.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.monetization_on, color: _accentGold, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        '${balance.toStringAsFixed(0)} FIT',
                        style: TextStyle(
                          color: _accentGold,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // القسم 2: شريط أزرار التنقل (مع أيقونات Material)
  // ==========================================================================
  Widget _buildSectionTabs() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0D28),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          _buildTabButton(0, 'Friends', Icons.people),
          _buildTabButton(1, 'Challenges', Icons.emoji_events),
          _buildTabButton(2, 'Info', Icons.settings),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
    final bool isActive = _selectedSectionIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSectionIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
              colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)],
            )
                : null,
            color: isActive ? null : const Color(0xFF1A0D28),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isActive ? Colors.white : Colors.white60, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white60,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // القسم 3: المحتوى الديناميكي
  // ==========================================================================
  Widget _buildDynamicContent({required Key key}) {
    switch (_selectedSectionIndex) {
      case 0:
        return _buildFriendsSection(key: key);
      case 1:
        return _buildChallengesSection(key: key);
      case 2:
        return _buildInfoSection(key: key);
      default:
        return const SizedBox.shrink();
    }
  }

  // ==========================================================================
  // القسم الفرعي 1: الأصدقاء (بدون أيقونات إضافية)
  // ==========================================================================
  Widget _buildFriendsSection({required Key key}) {
    final List<Map<String, dynamic>> friends = [
      {'name': 'Sarah', 'steps': 8420, 'color': Colors.pink, 'progress': 0.84},
      {'name': 'John', 'steps': 12350, 'color': Colors.blue, 'progress': 1.0},
      {'name': 'Emma', 'steps': 5600, 'color': Colors.purple, 'progress': 0.56},
      {'name': 'Michael', 'steps': 15400, 'color': Colors.green, 'progress': 1.0},
      {'name': 'Laura', 'steps': 9800, 'color': Colors.orange, 'progress': 0.98},
    ];

    final int totalFriends = friends.length;
    final int totalStepsToday = friends.map((friend) => friend['steps'] as int).reduce((a, b) => a + b);

    return Container(
      key: key,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0D28).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accentPurple.withOpacity(0.2), width: 1),
        boxShadow: [BoxShadow(color: _accentPurple.withOpacity(0.05), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان والإحصائيات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Friends',
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w600),
              ),
              // زر View All يعمل
              InkWell(
                onTap: () => context.push('/friends'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
          // إحصائيات الخطوات
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_walk, color: _accentPurple, size: 18),
                    const SizedBox(width: 8),
                    Text('Today\'s Steps', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
                  ],
                ),
                Text('${(totalStepsToday / 1000).toStringAsFixed(1)}k', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // قائمة الأصدقاء
          ...friends.map((friend) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  // صورة الصديق
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: friend['color'].withOpacity(0.15),
                      border: Border.all(color: friend['color'].withOpacity(0.2)),
                    ),
                    child: Center(
                      child: Text(
                        friend['name'][0],
                        style: TextStyle(color: friend['color'], fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(friend['name'], style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.directions_walk, color: Colors.white54, size: 12),
                            const SizedBox(width: 4),
                            Text('${friend['steps']}', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // شارة التقدم
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: friend['progress'] >= 1.0 ? Colors.green.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: friend['progress'] >= 1.0 ? Colors.green.withOpacity(0.3) : Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(
                      friend['progress'] >= 1.0 ? '✅ Done' : '${(friend['progress'] * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: friend['progress'] >= 1.0 ? Colors.green : Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
  // القسم الفرعي 2: التحديات
  // ==========================================================================
  Widget _buildChallengesSection({required Key key}) {
    final List<Map<String, dynamic>> challenges = [
      {'title': 'Step Challenge', 'color': _accentPink, 'reward': '500 FIT', 'progress': 0.45},
      {'title': 'Cardio Run', 'color': _accentPurple, 'reward': '300 FIT', 'progress': 0.80},
    ];

    return Container(
      key: key,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0D28).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Challenges',
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ...challenges.map((challenge) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    challenge['color'].withOpacity(0.1),
                    const Color(0xFF1A0D28),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: challenge['color'].withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: challenge['color'].withOpacity(0.15),
                      border: Border.all(color: challenge['color'].withOpacity(0.2)),
                    ),
                    child: Icon(Icons.emoji_events, color: challenge['color'], size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(challenge['title'], style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                        Text(challenge['reward'], style: TextStyle(color: challenge['color'].withOpacity(0.8), fontSize: 12)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: LinearProgressIndicator(
                      value: challenge['progress'],
                      backgroundColor: Colors.white.withOpacity(0.1),
                      color: challenge['color'],
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // زر تفاصيل التحدي يعمل
                  InkWell(
                    onTap: () => context.push('/challenge-details'),
                    child: const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 14),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 12),
          // زر إنشاء تحدٍ جديد يعمل
          InkWell(
            onTap: () => context.push('/create-challenge'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: _accentPink.withOpacity(0.3), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '+ Create New Challenge',
                  style: TextStyle(color: _accentPink, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // القسم الفرعي 3: المعلومات الشخصية
  // ==========================================================================
  Widget _buildInfoSection({required Key key}) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0D28).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Info',
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // --- الفئة 1: المعلومات الشخصية ---
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              children: [
                _buildInfoRow('Full Name', 'Noor Al Kafre', Icons.person),
                _buildInfoRow('Email Address', 'noor@fitcoin.app', Icons.email),
                _buildInfoRow('Username', '@noor_fit', Icons.alternate_email),
                _buildInfoRow('Member Since', 'January 2026', Icons.calendar_today),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // --- الفئة 2: الإعدادات ---
          Text(
            'Settings',
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              children: [
                // زر تعديل الملف الشخصي يفتح قائمة الإعدادات
                InkWell(
                  onTap: () => _showEditProfileBottomSheet(context),
                  child: _buildActionRow('Edit Profile', Icons.edit, _accentPurple),
                ),
                // زر سياسة الخصوصية يعمل
                InkWell(
                  onTap: () => context.push('/privacy'),
                  child: _buildActionRow('Privacy Policy', Icons.privacy_tip, Colors.white54),
                ),
                // زر شروط الخدمة يعمل
                InkWell(
                  onTap: () => context.push('/terms'),
                  child: _buildActionRow('Terms of Service', Icons.gavel, Colors.white54),
                ),
                // زر حذف الحساب
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    // هنا يتم وضع كود حذف الحساب
                    // مثال: ref.read(loginProvider.notifier).deleteAccount();
                  },
                  child: _buildActionRow('Delete Account', Icons.delete_forever, Colors.redAccent),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // --- الفئة 3: معلومات النظام ---
          Text(
            'System',
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              children: [
                _buildInfoRow('Version', '1.2.0', Icons.info_outline),
                _buildInfoRow('Last Update', '2 days ago', Icons.update),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.3), size: 18),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14))),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildActionRow(String label, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500))),
          const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 14),
        ],
      ),
    );
  }

  // ==========================================================================
  // القسم 4: زر تسجيل الخروج
  // ==========================================================================
  Widget _buildLogoutButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: () {
          context.go('/login');
        },
        borderRadius: BorderRadius.circular(20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.redAccent, size: 20),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}