import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitcoin/core/theme/app_colors.dart';
import 'package:fitcoin/core/theme/widgets/global_app_bar.dart';
import 'package:fitcoin/core/theme/widgets/starfield_background.dart';
import 'package:fitcoin/core/cache/cache_service.dart';
import 'package:fitcoin/features/profile/presentation/providers/profile_providers.dart';
import 'package:fitcoin/features/profile/presentation/states/profile_states.dart';
import 'package:fitcoin/features/profile/domain/entities/user_profile.dart';
import 'package:fitcoin/features/friends/presentation/providers/friends_providers.dart';
import 'package:fitcoin/features/friends/presentation/states/friends_states.dart';
import 'package:fitcoin/features/friends/domain/entities/friends_data.dart';
import 'package:fitcoin/features/challenges/presentation/providers/challenge_providers.dart';
import 'package:fitcoin/features/challenges/presentation/states/challenge_states.dart';
import 'package:fitcoin/features/challenges/presentation/widgets/challenge_card.dart';
import 'package:fitcoin/features/account/presentation/providers/account_providers.dart';
import 'package:fitcoin/features/step_counter/data/datasources/step_local_source.dart'; // ✅ Added

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
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileControllerProvider.notifier).loadProfile();
    });
  }

  // ==========================================================================
  // Avatar picking & upload
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
        });
        await ref
            .read(profileControllerProvider.notifier)
            .uploadAvatar(pickedFile.path);
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
                child: Text('Change Profile Picture',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPickerOption('Gallery', Icons.photo, ImageSource.gallery),
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

  // ==========================================================================
  // Edit Profile Bottom Sheet
  // ==========================================================================
  void _showEditProfileBottomSheet(UserProfile profile) {
    final nameController = TextEditingController(
      text: '${profile.firstName} ${profile.lastName}'.trim(),
    );
    final emailController = TextEditingController(text: profile.email);
    final phoneController = TextEditingController(text: profile.phone);
    final usernameController = TextEditingController(text: profile.username);

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
                child: Text('Edit Profile',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),

              // Full name
              const Text('Full Name', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameController,
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

              // Username
              const Text('Username', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: usernameController,
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

              // Email (read-only)
              const Text('Email Address', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                readOnly: true,
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

              // Phone
              const Text('Phone', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: phoneController,
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

              // Save button
              GestureDetector(
                onTap: () async {
                  final parts = nameController.text.trim().split(' ');
                  final firstName = parts.isNotEmpty ? parts.first : profile.firstName;
                  final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : profile.lastName;

                  await ref.read(profileControllerProvider.notifier).updateProfile(
                    firstName: firstName,
                    lastName: lastName,
                    username: usernameController.text.trim(),
                    phone: phoneController.text.trim(),
                  );
                  if (mounted) Navigator.pop(context);
                },
                child: Container(
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
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================================
  // Build method
  // ==========================================================================
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    return StarfieldBackground(
      child: Column(
        children: [
          GlobalAppBar(
            leading: null,
            titleWidget: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Profile',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
            actions: [
              InkWell(
                onTap: () => context.push('/settings'),
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
          Expanded(
            child: profileState is ProfileLoading
                ? const Center(child: CircularProgressIndicator())
                : profileState is ProfileError
                ? Center(child: Text(profileState.message, style: const TextStyle(color: Colors.red)))
                : profileState is ProfileLoaded
                ? _buildContent(profileState.profile)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(UserProfile profile) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          _buildProfileCard(profile),
          const SizedBox(height: 28),
          _buildSectionTabs(),
          const SizedBox(height: 28),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: _buildDynamicContent(profile),
          ),
          const SizedBox(height: 32),
          _buildLogoutButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==========================================================================
  // Profile card
  // ==========================================================================
  Widget _buildProfileCard(UserProfile profile) {
    Widget avatarWidget;
    if (_profileImage != null) {
      avatarWidget = ClipOval(
        child: Image.file(_profileImage!, width: 80, height: 80, fit: BoxFit.cover),
      );
    } else if (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty) {
      avatarWidget = ClipOval(
        child: Image.network(
          profile.avatarUrl!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildDefaultAvatar(profile),
        ),
      );
    } else {
      avatarWidget = _buildDefaultAvatar(profile);
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0D28).withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _accentPink.withOpacity(0.4), width: 1.5),
        boxShadow: [BoxShadow(color: _accentPink.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              avatarWidget,
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showImagePickerOptions(context),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profile.firstName} ${profile.lastName}',
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(profile.email, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
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
                        '${profile.fitcoinBalance} FIT',
                        style: TextStyle(color: _accentGold, fontSize: 13, fontWeight: FontWeight.bold),
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

  Widget _buildDefaultAvatar(UserProfile profile) {
    return Container(
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
          profile.firstName.isNotEmpty ? profile.firstName[0].toUpperCase() : 'U',
          style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ==========================================================================
  // Section tabs
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
                ? const LinearGradient(colors: [Color(0xFFD946EF), Color(0xFF8B5CF6)])
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
  // Dynamic content sections
  // ==========================================================================
  Widget _buildDynamicContent(UserProfile profile) {
    switch (_selectedSectionIndex) {
      case 0:
        return _buildFriendsSection(key: ValueKey(0));
      case 1:
        return _buildChallengesSection(key: ValueKey(1));
      case 2:
        return _buildInfoSection(profile, key: ValueKey(2));
      default:
        return const SizedBox.shrink();
    }
  }

  // ==========================================================================
  // Friends section (DYNAMIC - integrated with backend)
  // ==========================================================================
  Widget _buildFriendsSection({required Key key}) {
    final friendsState = ref.watch(friendsControllerProvider);

    if (friendsState is FriendsInitial) {
      Future.microtask(() {
        ref.read(friendsControllerProvider.notifier).loadFriends();
      });
    }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Friends', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w600)),
              Row(
                children: [
                  TextButton(
                    onPressed: () => context.push('/find-friends'),
                    child: Text('Find', style: TextStyle(color: _accentPurple, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () => context.push('/friend-requests'),
                    child: Text('Requests', style: TextStyle(color: _accentPurple, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  InkWell(
                    onTap: () => context.push('/friends'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _accentPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _accentPurple.withOpacity(0.2)),
                      ),
                      child: Text('View All', style: TextStyle(color: _accentPurple, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (friendsState is FriendsLoading && friendsState.cachedData == null)
            const Center(child: CircularProgressIndicator())
          else if (friendsState is FriendsError)
            Center(child: Text(friendsState.message, style: const TextStyle(color: Colors.red)))
          else if (friendsState is FriendsLoaded ||
                (friendsState is FriendsLoading && friendsState.cachedData != null))
              _buildFriendsList(friendsState is FriendsLoaded ? friendsState.data : (friendsState as FriendsLoading).cachedData!)
            else
              const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildFriendsList(FriendsData friendsData) {
    final friends = friendsData.friends;
    if (friends.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text('No friends yet', style: TextStyle(color: Colors.white54))),
      );
    }

    final totalTodaySteps = friends.fold<int>(0, (sum, f) => sum + f.todaySteps);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              Text('${(totalTodaySteps / 1000).toStringAsFixed(1)}k',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 16),
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
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _accentPurple.withOpacity(0.2),
                    border: Border.all(color: _accentPurple.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Text(
                      friend.name.isNotEmpty ? friend.name[0].toUpperCase() : '?',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(friend.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 6),
                          if (friend.isOnline)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.directions_walk, color: Colors.white54, size: 12),
                          const SizedBox(width: 4),
                          Text('${friend.todaySteps}', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: friend.isCompleted ? Colors.green.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: friend.isCompleted ? Colors.green.withOpacity(0.3) : Colors.white.withOpacity(0.1)),
                  ),
                  child: Text(
                    friend.isCompleted ? '✅ Done' : '${friend.progressPercent.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: friend.isCompleted ? Colors.green : Colors.white70,
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
    );
  }

  // ==========================================================================
  // Challenges section (DYNAMIC - integrated with backend)
  // ==========================================================================
  Widget _buildChallengesSection({required Key key}) {
    final challengesState = ref.watch(challengeControllerProvider);

    if (challengesState is ChallengesInitial) {
      Future.microtask(() {
        ref.read(challengeControllerProvider.notifier).loadChallenges();
      });
    }

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
          Text('Challenges',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          if (challengesState is ChallengesLoading &&
              challengesState.cachedChallenges == null)
            const Center(child: CircularProgressIndicator())
          else if (challengesState is ChallengesError)
            Center(child: Text(challengesState.message, style: const TextStyle(color: Colors.red)))
          else if (challengesState is ChallengesLoaded)
              ...challengesState.availableChallenges
                  .map((challenge) => ChallengeCard(challenge: challenge))
                  .toList(),
          const SizedBox(height: 16),
          // ✅ Create New Challenge button
          InkWell(
            onTap: () => context.push('/create-challenge'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: _accentPink.withOpacity(0.3), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text('+ Create New Challenge',
                    style: TextStyle(color: _accentPink, fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // Info section (real profile data)
  // ==========================================================================
  Widget _buildInfoSection(UserProfile profile, {required Key key}) {
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
          Text('Personal Info',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              children: [
                _buildInfoRow('Full Name', '${profile.firstName} ${profile.lastName}', Icons.person),
                _buildInfoRow('Email Address', profile.email, Icons.email),
                _buildInfoRow('Username', '@${profile.username}', Icons.alternate_email),
                _buildInfoRow('Phone', profile.phone, Icons.phone),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Settings',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w600)),
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
                InkWell(
                  onTap: () => _showEditProfileBottomSheet(profile),
                  child: _buildActionRow('Edit Profile', Icons.edit, _accentPurple),
                ),
                InkWell(
                  onTap: () => context.push('/privacy'),
                  child: _buildActionRow('Privacy Policy', Icons.privacy_tip, Colors.white54),
                ),
                InkWell(
                  onTap: () => context.push('/terms'),
                  child: _buildActionRow('Terms of Service', Icons.gavel, Colors.white54),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _showDeleteAccountDialog(),   // ✅ replaced with real method
                  child: _buildActionRow('Delete Account', Icons.delete_forever, Colors.redAccent),
                ),
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
          Expanded(child: Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14))),
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
          Expanded(child: Text(label, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500))),
          const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 14),
        ],
      ),
    );
  }

  // ==========================================================================
  // Delete Account Dialog
  // ==========================================================================
  Future<void> _showDeleteAccountDialog() async {
    final passwordController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A0D28),
        title: const Text('Delete Account', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your password to delete your account.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final password = passwordController.text.trim();
      if (password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password is required')),
        );
        return;
      }

      try {
        await ref.read(deactivateAccountProvider).call(password: password);  // ✅ pass password

        // ✅ Clear local step data before logging out
        final stepLocalSource = StepLocalSource();
        await stepLocalSource.clearAll();

        CacheService.clearAll();
        if (mounted) {
          context.go('/login');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to deactivate account: $e')),
          );
        }
      }
    }
  }

  // ==========================================================================
  // Logout button
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
        onTap: () async {
          // ✅ Clear local step data on logout
          final stepLocalSource = StepLocalSource();
          await stepLocalSource.clearAll();
          CacheService.clearAll();
          if (mounted) {
            context.go('/login');
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.redAccent, size: 20),
            SizedBox(width: 8),
            Text('Logout', style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}