import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final double opacity;

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white.withOpacity(0.15), Colors.transparent],
          ),

          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.08),
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),

            if (leading != null) ...[leading!, const SizedBox(width: 8)],

            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child:
                    titleWidget ??
                    (title != null
                        ? Text(
                            title!,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
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
