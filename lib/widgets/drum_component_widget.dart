import 'package:flutter/material.dart';
import '../models/drum_component_model.dart';
import '../services/drum_audio_service.dart';
import '../app/app_theme.dart';

class DrumComponentWidget extends StatefulWidget {
  final DrumComponentModel component;
  final DrumAudioService audioService;

  const DrumComponentWidget({
    super.key,
    required this.component,
    required this.audioService,
  });

  @override
  State<DrumComponentWidget> createState() => _DrumComponentWidgetState();
}

class _DrumComponentWidgetState extends State<DrumComponentWidget> {
  bool _isPressed = false;

  void _onPointerDown() {
    final nowMs = DateTime.now().millisecondsSinceEpoch.toDouble();
    if (!_isPressed) {
      setState(() {
        _isPressed = true;
      });
    }
    widget.audioService.playSound(
      widget.component.soundAsset,
      pointerDownMs: nowMs,
    );
  }

  void _onPointerUp() {
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
      enabled: true,
      label: widget.component.semanticLabel,
      hint: 'Tap to play ${widget.component.name}',
      onTap: () => widget.audioService.playSound(widget.component.soundAsset),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Listener(
          onPointerDown: (_) => _onPointerDown(),
          onPointerUp: (_) => _onPointerUp(),
          onPointerCancel: (_) => _onPointerUp(),
          child: RepaintBoundary(
            child: AnimatedScale(
              scale: _isPressed ? 0.96 : 1.0,
              duration: AppTheme.fastAnimation,
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                duration: AppTheme.fastAnimation,
                opacity: _isPressed ? 0.88 : 1.0,
                child: SizedBox.expand(
                  child: Transform.scale(
                    scale: 1.22,
                    child: Image.asset(
                      widget.component.imageAsset,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
