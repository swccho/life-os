import 'package:flutter/material.dart';

import '../../../../app/theme/tokens/app_spacing.dart';

/// LifeOS mark from Laravel `public/life-os-logo.png` (synced into app assets).
class AuthBrandLogo extends StatelessWidget {
  const AuthBrandLogo({super.key, this.height = 132});

  static const assetPath = 'assets/branding/life-os-logo.png';

  final double height;

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.sizeOf(context).width - AppSpacing.lg * 2;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: height,
            maxWidth: maxW.clamp(0, 320),
          ),
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
