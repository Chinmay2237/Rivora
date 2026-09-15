import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../core/constants/audio_asset_registry.dart';
import '../../../services/drum_audio_service.dart';
import '../../../widgets/audio_diagnostic_dialog.dart';

class XylophoneScreen extends StatefulWidget {
  const XylophoneScreen({super.key});

  @override
  State<XylophoneScreen> createState() => _XylophoneScreenState();
}

class _XylophoneScreenState extends State<XylophoneScreen> {
  final DrumAudioService _audioService = DrumAudioService();
  bool _isLoading = true;

  final List<_XyloNote> _notes = const [
    _XyloNote(color: Color(0xFFE53935), soundNumber: 1, name: 'C', label: 'Do'),
    _XyloNote(color: Color(0xFFFB8C00), soundNumber: 2, name: 'D', label: 'Re'),
    _XyloNote(color: Color(0xFFFDD835), soundNumber: 3, name: 'E', label: 'Mi'),
    _XyloNote(color: Color(0xFF43A047), soundNumber: 4, name: 'F', label: 'Fa'),
    _XyloNote(color: Color(0xFF00ACC1), soundNumber: 5, name: 'G', label: 'Sol'),
    _XyloNote(color: Color(0xFF1E88E5), soundNumber: 6, name: 'A', label: 'La'),
    _XyloNote(color: Color(0xFF8E24AA), soundNumber: 7, name: 'B', label: 'Si'),
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
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
            const SizedBox(width: 8),
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bug_report_rounded,
              color: AppTheme.accentViolet,
            ),
            onPressed: () {
              AudioDiagnosticDialog.show(context, _audioService);
            },
            tooltip: 'Audio Diagnostics',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Tap bars to play acoustic notes',
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
                          horizontal: 20, vertical: 8),
                      child: Stack(
                        children: [
                          // Wooden Frame Support Bars Top & Bottom
                          Positioned(
                            top: 20,
                            left: 0,
                            right: 0,
                            height: 14,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C1E18),
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(color: const Color(0xFF1A120E)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            height: 14,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C1E18),
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(color: const Color(0xFF1A120E)),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 4,
                                    offset: Offset(0, -2),
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
    // Proportional bar height scaling (Note 1 lowest pitch/longest bar -> Note 7 highest pitch/shortest bar)
    final verticalPadding = 4.0 + (widget.index * 6.0);

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
              scale: _isPressed ? 0.96 : 1.0,
              duration: AppTheme.fastAnimation,
              curve: Curves.easeOutCubic,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: verticalPadding,
                ),
                decoration: BoxDecoration(
                  color: widget.note.color,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.20),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.45),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Chrome Mounting Pin
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE5E7EB),
                        border: Border.all(
                          color: const Color(0xFF9CA3AF),
                          width: 1,
                        ),
                      ),
                    ),

                    // Note Pitch Name (C, D, E...) & Solfège Label (Do, Re...)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.note.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
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
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    // Bottom Chrome Mounting Pin
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE5E7EB),
                        border: Border.all(
                          color: const Color(0xFF9CA3AF),
                          width: 1,
                        ),
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
  final int soundNumber;
  final String name;
  final String label;

  const _XyloNote({
    required this.color,
    required this.soundNumber,
    required this.name,
    required this.label,
  });
}
