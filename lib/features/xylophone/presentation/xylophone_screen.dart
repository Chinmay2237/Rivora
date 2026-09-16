import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/constants/audio_asset_registry.dart';
import '../../../services/drum_audio_service.dart';

class XylophoneScreen extends StatefulWidget {
  const XylophoneScreen({super.key});

  @override
  State<XylophoneScreen> createState() => _XylophoneScreenState();
}

class _XylophoneScreenState extends State<XylophoneScreen> {
  final DrumAudioService _audioService = DrumAudioService();
  bool _isLoading = true;

  final List<_XyloNote> _notes = const [
    _XyloNote(
      color: Color(0xFFDC2626),
      accentColor: Color(0xFFEF4444),
      soundNumber: 1,
      name: 'C',
      label: 'Do',
    ),
    _XyloNote(
      color: Color(0xFFEA580C),
      accentColor: Color(0xFFF97316),
      soundNumber: 2,
      name: 'D',
      label: 'Re',
    ),
    _XyloNote(
      color: Color(0xFFD97706),
      accentColor: Color(0xFFF59E0B),
      soundNumber: 3,
      name: 'E',
      label: 'Mi',
    ),
    _XyloNote(
      color: Color(0xFF16A34A),
      accentColor: Color(0xFF22C55E),
      soundNumber: 4,
      name: 'F',
      label: 'Fa',
    ),
    _XyloNote(
      color: Color(0xFF0284C7),
      accentColor: Color(0xFF0EA5E9),
      soundNumber: 5,
      name: 'G',
      label: 'Sol',
    ),
    _XyloNote(
      color: Color(0xFF2563EB),
      accentColor: Color(0xFF3B82F6),
      soundNumber: 6,
      name: 'A',
      label: 'La',
    ),
    _XyloNote(
      color: Color(0xFF7C3AED),
      accentColor: Color(0xFF8B5CF6),
      soundNumber: 7,
      name: 'B',
      label: 'Si',
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

  void _playSound(int soundNumber) {
    final nowMs = DateTime.now().millisecondsSinceEpoch.toDouble();
    final path = AssetPaths.xyloNote(soundNumber);
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
            Image.asset(
              AssetPaths.rivoraSymbol,
              width: 22,
              height: 22,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.graphic_eq_rounded,
                size: 20,
                color: AppTheme.accentViolet,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Acoustic Xylophone',
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
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 6),
            const Text(
              'Tap bars to play acoustic notes (C4 – B4)',
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
                            AppTheme.successGreen),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: Stack(
                        children: [
                          // Mahogany Wood Frame Support Rails Top & Bottom
                          Positioned(
                            top: 24,
                            left: 0,
                            right: 0,
                            height: 18,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C1910),
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    Border.all(color: const Color(0xFF190D08)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 24,
                            left: 0,
                            right: 0,
                            height: 18,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C1910),
                                borderRadius: BorderRadius.circular(6),
                                border:
                                    Border.all(color: const Color(0xFF190D08)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 6,
                                    offset: Offset(0, -3),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 7 Acoustic Xylophone Bars
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (int i = 0; i < _notes.length; i++)
                                _XylophoneBar(
                                  note: _notes[i],
                                  totalNotes: _notes.length,
                                  index: i,
                                  onTap: () =>
                                      _playSound(_notes[i].soundNumber),
                                ),
                            ],
                          ),
                        ],
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

class _XylophoneBar extends StatefulWidget {
  final _XyloNote note;
  final int totalNotes;
  final int index;
  final VoidCallback onTap;

  const _XylophoneBar({
    required this.note,
    required this.totalNotes,
    required this.index,
    required this.onTap,
  });

  @override
  State<_XylophoneBar> createState() => _XylophoneBarState();
}

class _XylophoneBarState extends State<_XylophoneBar> {
  bool _isPressed = false;

  void _handleTapDown() {
    if (!_isPressed) {
      setState(() {
        _isPressed = true;
      });
    }
    widget.onTap();
  }

  void _handleTapUp() {
    if (_isPressed) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Acoustic bar length graduation (C4 longest bar -> B4 shortest bar)
    final verticalPadding = 2.0 + (widget.index * 7.0);

    return Expanded(
      child: Semantics(
        button: true,
        enabled: true,
        label: '${widget.note.name} ${widget.note.label} bar',
        hint: 'Tap to play note ${widget.note.name}',
        onTap: widget.onTap,
        child: Listener(
          onPointerDown: (_) => _handleTapDown(),
          onPointerUp: (_) => _handleTapUp(),
          onPointerCancel: (_) => _handleTapUp(),
          child: RepaintBoundary(
            child: AnimatedScale(
              scale: _isPressed ? 0.95 : 1.0,
              duration: AppTheme.fastAnimation,
              curve: Curves.easeOutCubic,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: verticalPadding,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _isPressed ? widget.note.accentColor : widget.note.color,
                      widget.note.color.withValues(alpha: 0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: _isPressed ? 0.45 : 0.22),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: _isPressed ? 3 : 8,
                      offset: Offset(0, _isPressed ? 1 : 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Chrome Screw Mounting Pin
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE2E8F0),
                        border: Border.all(
                          color: const Color(0xFF64748B),
                          width: 1.5,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),

                    // Pitch Letter Name (C, D, E...) & Solfège (Do, Re, Mi...)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.note.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.note.label,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.90),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    // Bottom Chrome Screw Mounting Pin
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE2E8F0),
                        border: Border.all(
                          color: const Color(0xFF64748B),
                          width: 1.5,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _XyloNote {
  final Color color;
  final Color accentColor;
  final int soundNumber;
  final String name;
  final String label;

  const _XyloNote({
    required this.color,
    required this.accentColor,
    required this.soundNumber,
    required this.name,
    required this.label,
  });
}

