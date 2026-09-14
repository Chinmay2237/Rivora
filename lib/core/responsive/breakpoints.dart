import 'package:flutter/material.dart';

enum LandscapeBreakpoint {
  compact, // < 600dp width or < 400dp height
  standard, // 600 - 1000dp width
  large, // > 1000dp width (tablets / expanded landscape)
}

abstract class Breakpoints {
  static LandscapeBreakpoint getBreakpoint(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    if (width < 600 || height < 380) {
      return LandscapeBreakpoint.compact;
    } else if (width > 1000) {
      return LandscapeBreakpoint.large;
    } else {
      return LandscapeBreakpoint.standard;
    }
  }
}
