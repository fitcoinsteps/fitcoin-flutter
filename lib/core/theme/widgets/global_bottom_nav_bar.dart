import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fitcoin/core/theme/app_colors.dart';

class GlobalBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlobalBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.10),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _navItems.length,
                  (index) => _buildNavItem(
                context,
                index,
                _navItems[index],
                currentIndex == index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context,
      int index,
      _NavItem item,
      bool isActive,
      ) {
    final iconData = isActive ? item.activeIcon : item.icon;
    final iconColor =
    isActive ? AppColors.primaryPink : Colors.white70;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isActive)
                ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 24,
                    sigmaY: 24,
                  ),
                  child: Icon(
                    iconData,
                    size: 40,
                    color: AppColors.primaryPink.withValues(
                      alpha: 0.20,
                    ),
                  ),
                ),

              if (isActive)
                ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 14,
                    sigmaY: 14,
                  ),
                  child: Icon(
                    iconData,
                    size: 34,
                    color: AppColors.primaryPink.withValues(
                      alpha: 0.55,
                    ),
                  ),
                ),

              Icon(
                iconData,
                size: 28,
                color: iconColor,
                shadows: isActive
                    ? [
                  const Shadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                  Shadow(
                    color: AppColors.primaryPink.withValues(
                      alpha: 0.30,
                    ),
                    blurRadius: 6,
                    offset: Offset.zero,
                  ),
                ]
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const List<_NavItem> _navItems = [
    _NavItem(Icons.home_outlined, Icons.home),
    _NavItem(Icons.attach_money_outlined, Icons.attach_money),
    _NavItem(Icons.card_giftcard_outlined, Icons.card_giftcard),
    _NavItem(Icons.person_outline, Icons.person),
  ];
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;

  const _NavItem(this.icon, this.activeIcon);
}