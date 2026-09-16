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
              // Studio Header Bar
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        AppConstants.appName,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        'Your studio, wherever you are.',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
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

              const SizedBox(height: 12),

              // Studio Section Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Make some music',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Play, practice, and explore instruments anywhere.',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 4 Playable Instrument Cards Grid (Responsive Row)
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = (constraints.maxWidth - 48) / 4;

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Acoustic Drum Kit
                          SizedBox(
                            width: cardWidth.clamp(200.0, 320.0),
                            height: constraints.maxHeight,
                            child: InstrumentCard(
                              title: 'Acoustic Drum Kit',
                              subtitle: '9 pieces • Ultra low latency',
                              description:
                                  'A responsive acoustic kit with natural drum placement.',
                              icon: Icons.album_rounded,
                              accentColor: AppTheme.accentViolet,
                              previewWidget: _buildDrumPreview(),
                              onTap: () {
                                Navigator.pushNamed(context, AppRouter.drumKit);
                              },
                            ),
                          ),
                          const SizedBox(width: 14),

                          // 2. Acoustic Xylophone
                          SizedBox(
                            width: cardWidth.clamp(200.0, 320.0),
                            height: constraints.maxHeight,
                            child: InstrumentCard(
                              title: 'Acoustic Xylophone',
                              subtitle: '7 notes • Color tuned keyboard',
                              description:
                                  'Play bright melodic notes with immediate tactile feedback.',
                              icon: Icons.music_note_rounded,
                              accentColor: AppTheme.successGreen,
                              previewWidget: _buildXylophonePreview(),
                              onTap: () {
                                Navigator.pushNamed(context, AppRouter.xylophone);
                              },
                            ),
                          ),
                          const SizedBox(width: 14),

                          // 3. Grand Piano
                          SizedBox(
                            width: cardWidth.clamp(200.0, 320.0),
                            height: constraints.maxHeight,
                            child: InstrumentCard(
                              title: 'Grand Piano',
                              subtitle: '13 keys • Chromatic scale (C4-C5)',
                              description:
                                  'Explore chords, melodies, and expressive keyboard playing.',
                              icon: Icons.piano_rounded,
                              accentColor: const Color(0xFF38BDF8),
                              previewWidget: _buildPianoPreview(),
                              onTap: () {
                                Navigator.pushNamed(context, AppRouter.piano);
                              },
                            ),
                          ),
                          const SizedBox(width: 14),

                          // 4. Electronic Drum Pad
                          SizedBox(
                            width: cardWidth.clamp(200.0, 320.0),
                            height: constraints.maxHeight,
                            child: InstrumentCard(
                              title: 'Electronic Drum Pad',
                              subtitle: '8 MPC pads • Rhythmic beat maker',
                              description:
                                  'Trigger punchy electronic sounds and build rhythmic patterns.',
                              icon: Icons.grid_view_rounded,
                              accentColor: const Color(0xFFF2B866),
                              previewWidget: _buildPadPreview(),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRouter.electronicPad);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Bottom Audio Engine Status Bar
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
                        'Audio Engine: Low-Latency Polyphony Active (37 Samples)',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Rivora Studio v1.0.0',
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
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF0F141F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF222B3A)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.trip_origin_rounded, size: 18, color: AppTheme.accentViolet),
          Icon(Icons.disc_full_rounded, size: 14, color: Color(0xFFFFC107)),
          Icon(Icons.album_rounded, size: 20, color: AppTheme.textPrimary),
          Icon(Icons.disc_full_rounded, size: 14, color: Color(0xFFFFC107)),
        ],
      ),
    );
  }

  Widget _buildXylophonePreview() {
    final colors = [
      const Color(0xFFE53935),
      const Color(0xFFFB8C00),
      const Color(0xFFFDD835),
      const Color(0xFF43A047),
      const Color(0xFF00ACC1),
      const Color(0xFF1E88E5),
      const Color(0xFF8E24AA),
    ];

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF0F141F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF222B3A)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final c in colors)
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
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
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF0F141F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF222B3A)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          8,
          (i) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: i % 2 == 1 ? const Color(0xFF334155) : const Color(0xFFF8FAFC),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(2)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPadPreview() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF0F141F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF222B3A)),
      ),
      padding: const EdgeInsets.all(4),
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Icon(Icons.trip_origin_rounded, size: 12, color: Color(0xFFE53935)),
          Icon(Icons.album_rounded, size: 12, color: Color(0xFFFB8C00)),
          Icon(Icons.pan_tool_rounded, size: 12, color: Color(0xFFFDD835)),
          Icon(Icons.disc_full_rounded, size: 12, color: Color(0xFF43A047)),
        ],
      ),
    );
  }
}
