import 'package:flutter/material.dart';
import '../../../app/app_router.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/constants/rivora_colors.dart';
import '../../../services/drum_audio_service.dart';
import '../../../core/constants/audio_asset_registry.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  final DrumAudioService _audioService = DrumAudioService();
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _initializeApp();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.2, end: 0.85).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
  }

  Future<void> _initializeApp() async {
    // Preload all 16 instrument WAV sound assets (drums + xylophone) into native SoundPool
    try {
      await _audioService.initialize(AudioAssetRegistry.allPaths);
    } catch (_) {
      // Non-blocking: continue even if audio initialization encounters network/system issues
    }

    // Ensure minimum animation presentation time before smooth navigation
    await Future.delayed(const Duration(milliseconds: 1150));
    if (mounted && !_navigated) {
      _navigated = true;
      Navigator.pushReplacementNamed(context, AppRouter.home);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RivoraColors.background,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final opacity = _fadeAnimation.value;
              final scale = _scaleAnimation.value;
              final glowAlpha = _glowAnimation.value;

              return Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Radial Violet Glow backdrop
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              RivoraColors.primary.withValues(
                                alpha: 0.35 * glowAlpha,
                              ),
                              RivoraColors.lavender.withValues(
                                alpha: 0.15 * glowAlpha,
                              ),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      // Approved Rivora Brand Symbol
                      Image.asset(
                        AssetPaths.splashScreen,
                        width: 180,
                        height: 180,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.graphic_eq_rounded,
                            size: 100,
                            color: RivoraColors.primary,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
