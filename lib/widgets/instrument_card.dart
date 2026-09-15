import 'package:flutter/material.dart';
import '../app/app_theme.dart';

class InstrumentCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color accentColor;
  final bool isAvailable;
  final Widget? previewWidget;
  final VoidCallback? onTap;

  const InstrumentCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.accentColor,
    this.isAvailable = true,
    this.previewWidget,
    this.onTap,
  });

  @override
  State<InstrumentCard> createState() => _InstrumentCardState();
}

class _InstrumentCardState extends State<InstrumentCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveOpacity = widget.isAvailable ? 1.0 : 0.55;
    final scale = _isPressed ? 0.98 : (_isHovered ? 1.01 : 1.0);

    return Semantics(
      button: widget.isAvailable,
      enabled: widget.isAvailable,
      label: '${widget.title}. ${widget.subtitle}. ${widget.description}.',
      hint: widget.isAvailable ? 'Double tap to open ${widget.title}' : 'Coming soon',
      child: MouseRegion(
        cursor: widget.isAvailable ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.isAvailable ? widget.onTap : null,
          child: AnimatedScale(
            scale: scale,
            duration: AppTheme.fastAnimation,
            curve: Curves.easeOutCubic,
            child: AnimatedOpacity(
              duration: AppTheme.normalAnimation,
              opacity: effectiveOpacity,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF161C26),
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(
                    color: widget.isAvailable
                        ? (_isHovered
                            ? widget.accentColor.withValues(alpha: 0.7)
                            : const Color(0xFF283446))
                        : const Color(0xFF1E2836),
                    width: 1.0,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Header Row: Icon + Title & Subtitle
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: widget.accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: widget.accentColor.withValues(alpha: 0.3),
                              width: 1.0,
                            ),
                          ),
                          child: Icon(
                            widget.icon,
                            size: 20,
                            color: widget.accentColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: widget.accentColor.withValues(alpha: 0.85),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Custom Visual Instrument Preview Element
                    if (widget.previewWidget != null) ...[
                      const SizedBox(height: 8),
                      widget.previewWidget!,
                    ],

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      widget.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11.5,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Restrained Action Button Row ("Open →" or "Coming soon")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.isAvailable ? 'READY' : 'IN DEVELOPMENT',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: widget.isAvailable
                                  ? AppTheme.textMuted
                                  : AppTheme.textMuted.withValues(alpha: 0.6),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.isAvailable ? 'Open' : 'Coming soon',
                              style: TextStyle(
                                color: widget.isAvailable
                                    ? widget.accentColor
                                    : AppTheme.textMuted,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (widget.isAvailable) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: widget.accentColor,
                              ),
                            ],
                          ],
                        ),
                      ],
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
