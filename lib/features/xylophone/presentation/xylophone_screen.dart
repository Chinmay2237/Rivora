import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../app/app_theme.dart';
import '../../../core/constants/asset_paths.dart';

class XylophoneScreen extends StatefulWidget {
  const XylophoneScreen({super.key});

  @override
  State<XylophoneScreen> createState() => _XylophoneScreenState();
}

class _XylophoneScreenState extends State<XylophoneScreen> {
  final List<AudioPlayer> _players = [];
  final List<_XyloNote> _notes = const [
    _XyloNote(color: Color(0xFFFF5252), soundNumber: 1, name: 'C', label: 'Do'),
    _XyloNote(color: Color(0xFFFF7A00), soundNumber: 2, name: 'D', label: 'Re'),
    _XyloNote(color: Color(0xFFFFD600), soundNumber: 3, name: 'E', label: 'Mi'),
    _XyloNote(color: Color(0xFF00E676), soundNumber: 4, name: 'F', label: 'Fa'),
    _XyloNote(
        color: Color(0xFF00B0FF), soundNumber: 5, name: 'G', label: 'Sol'),
    _XyloNote(color: Color(0xFF651FFF), soundNumber: 6, name: 'A', label: 'La'),
    _XyloNote(color: Color(0xFFAA00FF), soundNumber: 7, name: 'B', label: 'Si'),
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _notes.length; i++) {
      final player = AudioPlayer();
      player.setPlayerMode(PlayerMode.lowLatency).catchError((_) {});
      _players.add(player);
    }
  }

  @override
  void dispose() {
    for (final player in _players) {
      player.dispose().catchError((_) {});
    }
    super.dispose();
  }

  Future<void> _playSound(int index, int soundNumber) async {
    if (index < 0 || index >= _players.length) return;
    final player = _players[index];
    try {
      await player.stop();
      await player.play(AssetSource(AssetPaths.xyloNote(soundNumber)));
    } catch (_) {
      try {
        await player.play(AssetSource('note$soundNumber.wav'));
      } catch (_) {}
    }
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
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
            const SizedBox(width: 8),
            const Text(
              'Acoustic Xylophone',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),
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
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Tap bars to play melodic notes',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < _notes.length; i++)
                      _XylophoneBar(
                        note: _notes[i],
                        onTap: () => _playSound(i, _notes[i].soundNumber),
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
    setState(() {
      _isPressed = true;
    });
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
          child: AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: AppTheme.fastAnimation,
            curve: Curves.easeOutCubic,
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: widget.note.color,
                borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                boxShadow: [
                  BoxShadow(
                    color: widget.note.color.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    widget.note.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black45,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.note.label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
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
