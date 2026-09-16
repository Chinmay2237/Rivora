import 'package:flutter/material.dart';
import '../../../models/drum_component_model.dart';
import '../../../services/drum_audio_service.dart';
import '../../../widgets/drum_component_widget.dart';
import '../../../app/app_theme.dart';
import '../../../app/app_constants.dart';
import '../../../core/constants/audio_asset_registry.dart';

class DrumKitScreen extends StatefulWidget {
  const DrumKitScreen({super.key});

  @override
  State<DrumKitScreen> createState() => _DrumKitScreenState();
}

class _DrumKitScreenState extends State<DrumKitScreen> {
  final DrumAudioService _audioService = DrumAudioService();
  late final List<DrumComponentModel> _sortedComponents;
  bool _isLoading = true;
  bool _showLabels = false;

  @override
  void initState() {
    super.initState();
    final components = DrumComponentModel.defaultComponents;
    _sortedComponents = List<DrumComponentModel>.from(components)
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));
    _initAudio();
  }

  Future<void> _initAudio() async {
    await _audioService.initialize(AudioAssetRegistry.allPaths);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleLabels() {
    setState(() {
      _showLabels = !_showLabels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar Controls
            _DrumKitToolbar(
              audioService: _audioService,
              showLabels: _showLabels,
              onToggleLabels: _toggleLabels,
            ),

            // Interactive Acoustic Drum Stage
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.accentViolet),
                      ),
                    )
                  : RepaintBoundary(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final stageWidth = constraints.maxWidth;
                          final stageHeight = constraints.maxHeight;

                          return Container(
                            width: stageWidth,
                            height: stageHeight,
                            decoration: const BoxDecoration(
                              gradient: AppTheme.stageGradient,
                            ),
                            child: CustomPaint(
                              painter: _AcousticStageFloorPainter(),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: _sortedComponents.map((comp) {
                                  final left = comp.relativeLeft * stageWidth;
                                  final top = comp.relativeTop * stageHeight;
                                  final width =
                                      comp.relativeWidth * stageWidth;
                                  final height =
                                      comp.relativeHeight * stageHeight;

                                  return Positioned(
                                    left: left,
                                    top: top,
                                    width: width,
                                    height: height,
                                    child: DrumComponentWidget(
                                      component: comp,
                                      audioService: _audioService,
                                      showLabels: _showLabels,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrumKitToolbar extends StatefulWidget {
  final DrumAudioService audioService;
  final bool showLabels;
  final VoidCallback onToggleLabels;

  const _DrumKitToolbar({
    required this.audioService,
    required this.showLabels,
    required this.onToggleLabels,
  });

  @override
  State<_DrumKitToolbar> createState() => _DrumKitToolbarState();
}

class _DrumKitToolbarState extends State<_DrumKitToolbar> {
  @override
  Widget build(BuildContext context) {
    final isMuted = widget.audioService.isMuted;
    final hapticEnabled = widget.audioService.hapticEnabled;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: AppTheme.surfacePrimary,
      child: Row(
        children: [
          Semantics(
            button: true,
            label: 'Back to instrument selection',
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppTheme.textPrimary),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Back to Instruments',
            ),
          ),
          const SizedBox(width: 8),
          Image.asset(
            'assets/branding/rivora_symbol.png',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                AppConstants.appName,
                style: TextStyle(
                  color: AppTheme.accentViolet,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
              Text(
                'Acoustic Drum Kit',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),

          // Instrument Labels Toggle Button
          Semantics(
            button: true,
            label: widget.showLabels
                ? 'Hide instrument labels'
                : 'Show instrument labels',
            child: IconButton(
              icon: Icon(
                widget.showLabels
                    ? Icons.label_rounded
                    : Icons.label_outlined,
                color: widget.showLabels
                    ? AppTheme.accentViolet
                    : AppTheme.textSecondary,
              ),
              onPressed: widget.onToggleLabels,
              tooltip: widget.showLabels
                  ? 'Hide Instrument Labels'
                  : 'Show Instrument Labels',
            ),
          ),

          // Mute Toggle Button
          Semantics(
            button: true,
            label: isMuted ? 'Unmute sound' : 'Mute sound',
            child: IconButton(
              icon: Icon(
                isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                color: isMuted ? AppTheme.errorRed : AppTheme.successGreen,
              ),
              onPressed: () {
                setState(() {
                  widget.audioService.toggleMute();
                });
              },
              tooltip: isMuted ? 'Unmute Sound' : 'Mute Sound',
            ),
          ),

          // Haptics Toggle Button
          Semantics(
            button: true,
            label: hapticEnabled ? 'Disable haptics' : 'Enable haptics',
            child: IconButton(
              icon: Icon(
                hapticEnabled
                    ? Icons.vibration_rounded
                    : Icons.do_not_disturb_on_rounded,
                color: hapticEnabled
                    ? AppTheme.accentViolet
                    : AppTheme.textSecondary,
              ),
              onPressed: () {
                setState(() {
                  widget.audioService.toggleHaptic();
                });
              },
              tooltip: 'Toggle Haptics',
            ),
          ),
        ],
      ),
    );
  }
}

class _AcousticStageFloorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rugRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.68),
      width: size.width * 0.88,
      height: size.height * 0.58,
    );

    final rugPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF070A12).withValues(alpha: 0.9),
          const Color(0xFF090D18).withValues(alpha: 0.5),
          Colors.transparent,
        ],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(rugRect);

    canvas.drawOval(rugRect, rugPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
