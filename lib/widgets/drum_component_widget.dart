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
    if (!_isPressed) {
      setState(() {
        _isPressed = true;
      });
    }
    widget.audioService.playSound(widget.component.soundAsset);
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
              scale: _isPressed ? 0.92 : 1.0,
              duration: AppTheme.fastAnimation,
              curve: Curves.easeOutCubic,
              child: AnimatedContainer(
                duration: AppTheme.fastAnimation,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: _isPressed
                      ? [
                          BoxShadow(
                            color:
                                const Color(0xFFFFD700).withValues(alpha: 0.65),
                            blurRadius: 22,
                            spreadRadius: 4,
                          ),
                        ]
                      : const [],
                ),
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
    );
  }
}
