import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../app/app_constants.dart';
import '../constants/asset_paths.dart';
import '../constants/rivora_colors.dart';

class LandscapeGuard extends StatefulWidget {
  final Widget child;

  const LandscapeGuard({super.key, required this.child});

  @override
  State<LandscapeGuard> createState() => _LandscapeGuardState();
}

class _LandscapeGuardState extends State<LandscapeGuard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isPortrait = size.height > size.width;

    if (isPortrait) {
      return Scaffold(
        backgroundColor: RivoraColors.background,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(
              gradient: AppTheme.backgroundGradient,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rivora Symbol Branding Logo
                Image.asset(
                  AssetPaths.rivoraSymbol,
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.graphic_eq_rounded,
                    size: 64,
                    color: RivoraColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                RotationTransition(
                  turns: _rotationAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: RivoraColors.primary.withValues(alpha: 0.15),
                      border: Border.all(
                        color: RivoraColors.primary.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.screen_rotation_rounded,
                      size: 40,
                      color: RivoraColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Please Rotate Your Device',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: RivoraColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '${AppConstants.appName} works best in landscape mode.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: RivoraColors.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}
