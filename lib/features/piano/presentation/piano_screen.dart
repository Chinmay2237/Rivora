import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/constants/audio_asset_registry.dart';
import '../../../services/drum_audio_service.dart';

class PianoScreen extends StatefulWidget {
  const PianoScreen({super.key});

  @override
  State<PianoScreen> createState() => _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen> {
  final DrumAudioService _audioService = DrumAudioService();
  bool _isLoading = true;
  bool _showLabels = true;

  final List<_PianoKeySpec> _whiteKeys = const [
    _PianoKeySpec(noteKey: 'c4', label: 'C4', isBlack: false),
    _PianoKeySpec(noteKey: 'd4', label: 'D4', isBlack: false),
    _PianoKeySpec(noteKey: 'e4', label: 'E4', isBlack: false),
    _PianoKeySpec(noteKey: 'f4', label: 'F4', isBlack: false),
    _PianoKeySpec(noteKey: 'g4', label: 'G4', isBlack: false),
    _PianoKeySpec(noteKey: 'a4', label: 'A4', isBlack: false),
    _PianoKeySpec(noteKey: 'b4', label: 'B4', isBlack: false),
    _PianoKeySpec(noteKey: 'c5', label: 'C5', isBlack: false),
  ];

  // Black key placement relative to white key indices:
  // C#4 (after C4 idx 0), D#4 (after D4 idx 1), F#4 (after F4 idx 3), G#4 (after G4 idx 4), A#4 (after A4 idx 5)
  final List<_PianoKeySpec> _blackKeys = const [
    _PianoKeySpec(noteKey: 'cs4', label: 'C#4', isBlack: true, whiteIndexLeft: 0),
    _PianoKeySpec(noteKey: 'ds4', label: 'D#4', isBlack: true, whiteIndexLeft: 1),
    _PianoKeySpec(noteKey: 'fs4', label: 'F#4', isBlack: true, whiteIndexLeft: 3),
    _PianoKeySpec(noteKey: 'gs4', label: 'G#4', isBlack: true, whiteIndexLeft: 4),
    _PianoKeySpec(noteKey: 'as4', label: 'A#4', isBlack: true, whiteIndexLeft: 5),
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

  void _playNote(String noteKey) {
    final nowMs = DateTime.now().millisecondsSinceEpoch.toDouble();
    final path = AssetPaths.pianoNote(noteKey);
    _audioService.playSound(path, pointerDownMs: nowMs);
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
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.piano_rounded, color: AppTheme.accentViolet, size: 22),
            const SizedBox(width: 8),
            const Text(
              'Grand Piano',
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
              _showLabels ? Icons.label_rounded : Icons.label_outlined,
              color: _showLabels ? AppTheme.accentViolet : AppTheme.textSecondary,
            ),
            onPressed: _toggleLabels,
            tooltip: _showLabels ? 'Hide Note Labels' : 'Show Note Labels',
          ),
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
            const SizedBox(height: 6),
            const Text(
              'Tap keys to play acoustic piano notes (C4 – C5)',
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
                          horizontal: 20, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1510),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF382318), width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(6),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final totalWidth = constraints.maxWidth;
                            final totalHeight = constraints.maxHeight;
                            final whiteKeyWidth = totalWidth / _whiteKeys.length;
                            final blackKeyWidth = whiteKeyWidth * 0.58;
                            final blackKeyHeight = totalHeight * 0.58;

                            return Stack(
                              children: [
                                // 1. White Keys Row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    for (int i = 0; i < _whiteKeys.length; i++)
                                      _PianoWhiteKeyWidget(
                                        spec: _whiteKeys[i],
                                        showLabel: _showLabels,
                                        onTap: () =>
                                            _playNote(_whiteKeys[i].noteKey),
                                      ),
                                  ],
                                ),

                                // 2. Black Keys Stack Overlay
                                for (final blackSpec in _blackKeys)
                                  Positioned(
                                    left: (blackSpec.whiteIndexLeft! + 1) *
                                            whiteKeyWidth -
                                        (blackKeyWidth / 2),
                                    top: 0,
                                    width: blackKeyWidth,
                                    height: blackKeyHeight,
                                    child: _PianoBlackKeyWidget(
                                      spec: blackSpec,
                                      showLabel: _showLabels,
                                      onTap: () => _playNote(blackSpec.noteKey),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
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

class _PianoWhiteKeyWidget extends StatefulWidget {
  final _PianoKeySpec spec;
  final bool showLabel;
  final VoidCallback onTap;

  const _PianoWhiteKeyWidget({
    required this.spec,
    required this.showLabel,
    required this.onTap,
  });

  @override
  State<_PianoWhiteKeyWidget> createState() => _PianoWhiteKeyWidgetState();
}

class _PianoWhiteKeyWidgetState extends State<_PianoWhiteKeyWidget> {
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
    return Expanded(
      child: Semantics(
        button: true,
        label: 'Piano key ${widget.spec.label}',
        hint: 'Tap to play ${widget.spec.label}',
        onTap: widget.onTap,
        child: Listener(
          onPointerDown: (_) => _handlePointerDown(),
          onPointerUp: (_) => _handlePointerUp(),
          onPointerCancel: (_) => _handlePointerUp(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _isPressed
                    ? [const Color(0xFFCBD5E1), const Color(0xFFE2E8F0)]
                    : [const Color(0xFFFFFFFF), const Color(0xFFF1F5F9)],
              ),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(8.0)),
              border: Border.all(color: const Color(0xFF94A3B8), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _isPressed ? 0.2 : 0.4),
                  blurRadius: _isPressed ? 2 : 5,
                  offset: Offset(0, _isPressed ? 1 : 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.showLabel)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      widget.spec.label,
                      style: TextStyle(
                        color: _isPressed ? const Color(0xFF0F172A) : const Color(0xFF334155),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PianoBlackKeyWidget extends StatefulWidget {
  final _PianoKeySpec spec;
  final bool showLabel;
  final VoidCallback onTap;

  const _PianoBlackKeyWidget({
    required this.spec,
    required this.showLabel,
    required this.onTap,
  });

  @override
  State<_PianoBlackKeyWidget> createState() => _PianoBlackKeyWidgetState();
}

class _PianoBlackKeyWidgetState extends State<_PianoBlackKeyWidget> {
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
      label: 'Piano sharp key ${widget.spec.label}',
      hint: 'Tap to play ${widget.spec.label}',
      onTap: widget.onTap,
      child: Listener(
        onPointerDown: (_) => _handlePointerDown(),
        onPointerUp: (_) => _handlePointerUp(),
        onPointerCancel: (_) => _handlePointerUp(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _isPressed
                  ? [const Color(0xFF334155), const Color(0xFF1E293B)]
                  : [const Color(0xFF1E293B), const Color(0xFF090D16)],
            ),
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(6.0)),
            border: Border.all(
              color: _isPressed ? AppTheme.accentViolet : const Color(0xFF475569),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.65),
                blurRadius: _isPressed ? 3 : 7,
                offset: Offset(0, _isPressed ? 2 : 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.showLabel)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    widget.spec.label,
                    style: TextStyle(
                      color: _isPressed ? Colors.white : const Color(0xFFCBD5E1),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PianoKeySpec {
  final String noteKey;
  final String label;
  final bool isBlack;
  final int? whiteIndexLeft;

  const _PianoKeySpec({
    required this.noteKey,
    required this.label,
    required this.isBlack,
    this.whiteIndexLeft,
  });
}

