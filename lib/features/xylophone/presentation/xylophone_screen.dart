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
    _XyloNote(color: Color(0xFFB71C1C), soundNumber: 1, name: 'C', label: 'Do'),
    _XyloNote(color: Color(0xFFD35400), soundNumber: 2, name: 'D', label: 'Re'),
    _XyloNote(color: Color(0xFFD4AC0D), soundNumber: 3, name: 'E', label: 'Mi'),
    _XyloNote(color: Color(0xFF1B5E20), soundNumber: 4, name: 'F', label: 'Fa'),
    _XyloNote(color: Color(0xFF00695C), soundNumber: 5, name: 'G', label: 'Sol'),
    _XyloNote(color: Color(0xFF0D47A1), soundNumber: 6, name: 'A', label: 'La'),
    _XyloNote(color: Color(0xFF4A148C), soundNumber: 7, name: 'B', label: 'Si'),
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
            const SizedBox(height: 10),
            const Text(
              'Tap bars to play acoustic notes',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.successGreen),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Stack(
                        children: [
                          // Wooden Frame Support Bars Top & Bottom
                          Positioned(
                            top: 24,
                            left: 0,
                            right: 0,
                            height: 12,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C1E18),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: const Color(0xFF1A120E)),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 24,
                            left: 0,
                            right: 0,
                            height: 12,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C1E18),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: const Color(0xFF1A120E)),
                              ),
                            ),
                          ),

                          // 7 Xylophone Bars
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (int i = 0; i < _notes.length; i++)
                                _XylophoneBar(
                                  note: _notes[i],
                                  onTap: () => _playSound(_notes[i].soundNumber),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _XylophoneBar extends StatefulWidget {
  final _XyloNote note;
  final VoidCallback onTap;

  const _XylophoneBar({
    required this.note,
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
                margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: widget.note.color,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1.0,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Chrome Pin
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD1D5DB),
                      ),
                    ),

                    // Note Label (C, D, E...) and Solfège (Do, Re...)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.note.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.note.label,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    // Bottom Chrome Pin
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD1D5DB),
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
