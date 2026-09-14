import 'package:flutter/material.dart';
import '../app/app_theme.dart';

class InstrumentCard extends StatelessWidget {
  final String title;
  final String description;
  final String tag;
  final IconData icon;
  final Color accentColor;
  final List<Color> gradientColors;
  final bool isAvailable;
  final VoidCallback? onTap;

  const InstrumentCard({
    super.key,
    required this.title,
    required this.description,
    required this.tag,
    required this.icon,
    required this.accentColor,
    required this.gradientColors,
    this.isAvailable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOpacity = isAvailable ? 1.0 : 0.6;

    return Semantics(
      button: isAvailable,
      enabled: isAvailable,
      label: '$title instrument card. $description. $tag.',
      hint: isAvailable ? 'Double tap to open $title' : 'Coming soon',
      child: MouseRegion(
        cursor:
            isAvailable ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: AnimatedOpacity(
          duration: AppTheme.normalAnimation,
          opacity: effectiveOpacity,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              border: Border.all(
                color: isAvailable
                    ? accentColor.withValues(alpha: 0.35)
                    : Colors.white.withValues(alpha: 0.08),
                width: 1.5,
              ),
              boxShadow: isAvailable
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                onTap: isAvailable ? onTap : null,
                splashColor: accentColor.withValues(alpha: 0.2),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          icon,
                          size: 32,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: isAvailable
                                          ? AppTheme.textPrimary
                                          : AppTheme.textSecondary,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (isAvailable)
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: accentColor,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              description,
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
      ),
    );
  }
}
