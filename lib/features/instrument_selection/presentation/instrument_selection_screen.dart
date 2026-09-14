import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../app/app_router.dart';
import '../../../app/app_constants.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../widgets/instrument_card.dart';

class InstrumentSelectionScreen extends StatelessWidget {
  const InstrumentSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar Header with Official Rivora Logo & Settings Access
              Row(
                children: [
                  Image.asset(
                    AssetPaths.rivoraSymbol,
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.accentViolet.withValues(alpha: 0.2),
                      ),
                      child: const Icon(
                        Icons.graphic_eq_rounded,
                        size: 20,
                        color: AppTheme.accentViolet,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        AppConstants.appName,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3.0,
                        ),
                      ),
                      Text(
                        AppConstants.appTagline,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Semantics(
                    button: true,
                    label: 'Settings',
                    hint: 'Open Rivora application settings',
                    child: IconButton(
                      icon: const Icon(Icons.settings_rounded,
                          color: AppTheme.textPrimary),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.settings);
                      },
                      tooltip: 'Settings',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Instrument Cards Horizontal Landscape Grid
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 320,
                        child: InstrumentCard(
                          title: 'Interactive Drum Kit',
                          description:
                              'Full 10-piece acoustic drum set with first-person POV, instant touch feedback & low-latency audio.',
                          tag: '10 Components • Multi-Touch',
                          icon: Icons.album_rounded,
                          accentColor: AppTheme.accentViolet,
                          gradientColors: const [
                            Color(0xFF231E35),
                            Color(0xFF191624)
                          ],
                          onTap: () {
                            Navigator.pushNamed(context, AppRouter.drumKit);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 320,
                        child: InstrumentCard(
                          title: 'Acoustic Xylophone',
                          description:
                              'Classic 7-note color-tuned xylophone bars with rich acoustic resonances.',
                          tag: '7 Notes • Tuned Acoustic',
                          icon: Icons.music_note_rounded,
                          accentColor: AppTheme.successGreen,
                          gradientColors: const [
                            Color(0xFF1B2B24),
                            Color(0xFF141F1A)
                          ],
                          onTap: () {
                            Navigator.pushNamed(context, AppRouter.xylophone);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      const SizedBox(
                        width: 320,
                        child: InstrumentCard(
                          title: 'Grand Piano',
                          description:
                              'Full 88-key acoustic grand piano with velocity modeling and pedal sustain.',
                          tag: 'Coming Soon',
                          icon: Icons.piano_rounded,
                          accentColor: AppTheme.textSecondary,
                          gradientColors: [
                            Color(0xFF1C1C24),
                            Color(0xFF14141A)
                          ],
                          isAvailable: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
