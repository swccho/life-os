import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/tokens/app_colors.dart';

/// Immersive gradient background with soft neon glows — wrap screen bodies.
class AppScreenBackground extends StatelessWidget {
  const AppScreenBackground({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    // Edge-to-edge Android often reports padding.top == 0 while icons still draw
    // in viewPadding; ensure we reserve at least that space below the status bar.
    final minInsets = EdgeInsets.only(
      top: max(mq.viewPadding.top, mq.padding.top),
      left: max(mq.viewPadding.left, mq.padding.left),
      right: max(mq.viewPadding.right, mq.padding.right),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.bgPrimary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgGradientStart,
              AppColors.bgGradientMid,
              AppColors.bgGradientEnd,
            ],
            stops: [0.0, 0.42, 1.0],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: -100,
              right: -80,
              child: IgnorePointer(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accentPurple.withValues(alpha: 0.22),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: -100,
              child: IgnorePointer(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.neonPrimary.withValues(alpha: 0.14),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 180,
              left: -40,
              child: IgnorePointer(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accentPink.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              minimum: minInsets,
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
