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
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar: Clean Rivora Branding & Settings Access
              Row(
                children: [
                  Image.asset(
                    AssetPaths.rivoraSymbol,
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.graphic_eq_rounded,
                      size: 24,
                      color: AppTheme.accentViolet,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    AppConstants.appName,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const Spacer(),
                  Semantics(
                    button: true,
                    label: 'Settings',
                    hint: 'Open Rivora application settings',
                    child: IconButton(
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: AppTheme.textSecondary,
                        size: 22,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.settings);
                      },
                      tooltip: 'Settings',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Section Header: "Your instruments"
              const Text(
                'Your instruments',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 10),

              // Instrument Selection Grid (Landscape Layout)
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = (constraints.maxWidth - 32) / 3;

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Interactive Drum Kit
                          SizedBox(
                            width: cardWidth.clamp(260.0, 380.0),
                            height: constraints.maxHeight,
                            child: InstrumentCard(
                              title: 'Interactive Drum Kit',
                              subtitle: 'Acoustic percussion • 10 playable pieces',
                              description:
                                  'Full 10-piece drum setup with multi-touch low-latency polyphony.',
                              icon: Icons.album_rounded,
                              accentColor: AppTheme.accentViolet,
                              previewWidget: _buildDrumPreview(),
                              onTap: () {
                                Navigator.pushNamed(context, AppRouter.drumKit);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),

                          // 2. Acoustic Xylophone
                          SizedBox(
                            width: cardWidth.clamp(260.0, 380.0),
                            height: constraints.maxHeight,
                            child: InstrumentCard(
                              title: 'Acoustic Xylophone',
                              subtitle: 'Seven-note melodic instrument • 7 notes',
                              description:
                                  'Color-tuned 7-note acoustic xylophone with warm resonance.',
                              icon: Icons.music_note_rounded,
                              accentColor: AppTheme.successGreen,
                              previewWidget: _buildXylophonePreview(),
                              onTap: () {
                                Navigator.pushNamed(context, AppRouter.xylophone);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),

                          // 3. Piano & Synth (Coming Soon)
                          SizedBox(
                            width: cardWidth.clamp(260.0, 380.0),
                            height: constraints.maxHeight,
                            child: InstrumentCard(
                              title: 'Piano & Synth',
                              subtitle: 'Coming soon',
                              description:
                                  '88-key acoustic grand piano with velocity sustain modeling.',
                              icon: Icons.piano_rounded,
                              accentColor: AppTheme.textMuted,
                              previewWidget: _buildPianoPreview(),
                              isAvailable: false,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Bottom Subtle Audio Status Area
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.successGreen,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Audio Engine: Active (Low Latency)',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Rivora v1.0.0',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrumPreview() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF0F141F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF222B3A)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.trip_origin_rounded, size: 20, color: AppTheme.accentViolet),
          Icon(Icons.disc_full_rounded, size: 16, color: Color(0xFFFFC107)),
          Icon(Icons.album_rounded, size: 22, color: AppTheme.textPrimary),
          Icon(Icons.disc_full_rounded, size: 16, color: Color(0xFFFFC107)),
          Icon(Icons.trip_origin_rounded, size: 18, color: AppTheme.accentViolet),
        ],
      ),
    );
  }

  Widget _buildXylophonePreview() {
    final colors = [
      const Color(0xFFB71C1C),
      const Color(0xFFD35400),
      const Color(0xFFD4AC0D),
      const Color(0xFF1B5E20),
      const Color(0xFF00695C),
      const Color(0xFF0D47A1),
      const Color(0xFF4A148C),
    ];

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF0F141F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF222B3A)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final c in colors)
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPianoPreview() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF0F141F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF222B3A)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          10,
          (i) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: i % 2 == 1 ? const Color(0xFF283446) : const Color(0xFF1A2230),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(2)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
