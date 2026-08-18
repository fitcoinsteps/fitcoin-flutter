import 'package:flutter/material.dart';
import 'package:fitcoin/core/theme/app_colors.dart';

class GlobalAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final double opacity; // kept for compatibility

  const GlobalAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.opacity = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        height: kToolbarHeight,
        color: Colors.white.withValues(alpha: 0.10),
        child: Row(
          children: [
            const SizedBox(width: 16),

            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],

            Expanded(
              child: Center(
                child: titleWidget ??
                    (title != null
                        ? Text(
                      title!,
                      style: TextStyle(
                        color: AppColors.primaryPink,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            color: AppColors.primaryPink
                                .withValues(alpha: 0.5),
                            blurRadius: 12,
                            offset: Offset.zero,
                          ),
                          Shadow(
                            color: AppColors.primaryPink
                                .withValues(alpha: 0.2),
                            blurRadius: 24,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                    )
                        : const SizedBox()),
              ),
            ),

            if (actions != null) ...actions!,

            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}