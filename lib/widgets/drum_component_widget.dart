import 'package:flutter/material.dart';
import '../models/drum_component_model.dart';
import '../services/drum_audio_service.dart';
import '../app/app_theme.dart';

class DrumComponentWidget extends StatefulWidget {
  final DrumComponentModel component;
  final DrumAudioService audioService;
  final bool showLabels;

  const DrumComponentWidget({
    super.key,
    required this.component,
    required this.audioService,
    this.showLabels = false,
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
              scale: _isPressed ? 0.95 : 1.0,
              duration: AppTheme.fastAnimation,
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                duration: AppTheme.fastAnimation,
                opacity: _isPressed ? 0.90 : 1.0,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Main Drum / Cymbal Image Asset
                    Positioned.fill(
                      child: Image.asset(
                        widget.component.imageAsset,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.medium,
                      ),
                    ),

                    // Subtle Pressed Glow Overlay
                    if (_isPressed)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.accentHighlight
                                .withValues(alpha: 0.15),
                          ),
                        ),
                      ),

                    // Optional Minimal Instrument Label
                    if (widget.showLabels)
                      Positioned(
                        bottom: 4,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.white24,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              widget.component.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
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
