import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/constants/audio_asset_registry.dart';
import '../../../services/drum_audio_service.dart';

class ElectronicPadScreen extends StatefulWidget {
  const ElectronicPadScreen({super.key});

  @override
  State<ElectronicPadScreen> createState() => _ElectronicPadScreenState();
}

class _ElectronicPadScreenState extends State<ElectronicPadScreen> {
  final DrumAudioService _audioService = DrumAudioService();
  bool _isLoading = true;

  final List<_PadSpec> _pads = const [
    _PadSpec(
      id: 'pad_kick',
      name: '808 Kick',
      soundPath: AssetPaths.padKick,
      color: Color(0xFFE53935),
      icon: Icons.trip_origin_rounded,
    ),
    _PadSpec(
      id: 'pad_snare',
      name: 'Trap Snare',
      soundPath: AssetPaths.padSnare,
      color: Color(0xFFFB8C00),
      icon: Icons.album_rounded,
    ),
    _PadSpec(
      id: 'pad_clap',
      name: 'Hand Clap',
      soundPath: AssetPaths.padClap,
      color: Color(0xFFFDD835),
      icon: Icons.pan_tool_rounded,
    ),
    _PadSpec(
      id: 'pad_hihat_closed',
      name: 'Closed Hat',
      soundPath: AssetPaths.padHiHatClosed,
      color: Color(0xFF43A047),
      icon: Icons.disc_full_rounded,
    ),
    _PadSpec(
      id: 'pad_hihat_open',
      name: 'Open Hat',
      soundPath: AssetPaths.padHiHatOpen,
      color: Color(0xFF00ACC1),
      icon: Icons.adjust_rounded,
    ),
    _PadSpec(
      id: 'pad_tom',
      name: '808 Tom',
      soundPath: AssetPaths.padTom,
      color: Color(0xFF1E88E5),
      icon: Icons.circle_outlined,
    ),
    _PadSpec(
      id: 'pad_synth_hit',
      name: 'Synth Stab',
      soundPath: AssetPaths.padSynthHit,
      color: Color(0xFF8E24AA),
      icon: Icons.flash_on_rounded,
    ),
    _PadSpec(
      id: 'pad_rim',
      name: 'Rim Shot',
      soundPath: AssetPaths.padRim,
      color: Color(0xFFEC407A),
      icon: Icons.blur_circular_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
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

  void _playPad(String path) {
    final nowMs = DateTime.now().millisecondsSinceEpoch.toDouble();
    _audioService.playSound(path, pointerDownMs: nowMs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.grid_view_rounded,
                color: AppTheme.accentViolet, size: 22),
            const SizedBox(width: 8),
            const Text(
              'Electronic Drum Pad',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppTheme.surfacePrimary,
        elevation: 0,
        leading: Semantics(
          button: true,
          label: 'Back to instrument selection',
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _audioService.isMuted
                  ? Icons.volume_off_rounded
                  : Icons.volume_up_rounded,
              color: _audioService.isMuted
                  ? AppTheme.errorRed
                  : AppTheme.successGreen,
            ),
            onPressed: () {
              setState(() {
                _audioService.toggleMute();
              });
            },
            tooltip: 'Toggle Mute',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Tap MPC beat pads for electronic sounds',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.accentViolet),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.25,
                        ),
                        itemCount: _pads.length,
                        itemBuilder: (context, index) {
                          final pad = _pads[index];
                          return _MpcPadWidget(
                            pad: pad,
                            onTap: () => _playPad(pad.soundPath),
                          );
                        },
                      ),
                    ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _MpcPadWidget extends StatefulWidget {
  final _PadSpec pad;
  final VoidCallback onTap;

  const _MpcPadWidget({
    required this.pad,
    required this.onTap,
  });

  @override
  State<_MpcPadWidget> createState() => _MpcPadWidgetState();
}

class _MpcPadWidgetState extends State<_MpcPadWidget> {
  bool _isPressed = false;

  void _handlePointerDown() {
    if (!_isPressed) {
      setState(() {
        _isPressed = true;
      });
    }
    widget.onTap();
  }

  void _handlePointerUp() {
    if (_isPressed) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.pad.name,
      hint: 'Tap to trigger ${widget.pad.name}',
      onTap: widget.onTap,
      child: Listener(
        onPointerDown: (_) => _handlePointerDown(),
        onPointerUp: (_) => _handlePointerUp(),
        onPointerCancel: (_) => _handlePointerUp(),
        child: RepaintBoundary(
          child: AnimatedScale(
            scale: _isPressed ? 0.94 : 1.0,
            duration: AppTheme.fastAnimation,
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: AppTheme.fastAnimation,
              decoration: BoxDecoration(
                color: _isPressed
                    ? widget.pad.color.withValues(alpha: 0.9)
                    : AppTheme.surfaceSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isPressed
                      ? Colors.white
                      : widget.pad.color.withValues(alpha: 0.5),
                  width: _isPressed ? 2.0 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? widget.pad.color.withValues(alpha: 0.6)
                        : Colors.black.withValues(alpha: 0.4),
                    blurRadius: _isPressed ? 12 : 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.pad.icon,
                    size: 24,
                    color: _isPressed ? Colors.white : widget.pad.color,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.pad.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          _isPressed ? Colors.white : AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PadSpec {
  final String id;
  final String name;
  final String soundPath;
  final Color color;
  final IconData icon;

  const _PadSpec({
    required this.id,
    required this.name,
    required this.soundPath,
    required this.color,
    required this.icon,
  });
}
