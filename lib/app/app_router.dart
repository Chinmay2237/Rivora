import 'package:flutter/material.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/instrument_selection/presentation/instrument_selection_screen.dart';
import '../features/drum_kit/presentation/drum_kit_screen.dart';
import '../features/xylophone/presentation/xylophone_screen.dart';
import '../features/piano/presentation/piano_screen.dart';
import '../features/electronic_pad/presentation/electronic_pad_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

abstract class AppRouter {
  static const String splash = '/splash';
  static const String home = '/';
  static const String drumKit = '/drum_kit';
  static const String xylophone = '/xylophone';
  static const String piano = '/piano';
  static const String electronicPad = '/electronic_pad';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        home: (_) => const InstrumentSelectionScreen(),
        drumKit: (_) => const DrumKitScreen(),
        xylophone: (_) => const XylophoneScreen(),
        piano: (_) => const PianoScreen(),
        electronicPad: (_) => const ElectronicPadScreen(),
        settings: (_) => const SettingsScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return _buildRoute(const SplashScreen(), routeSettings);
      case home:
        return _buildRoute(const InstrumentSelectionScreen(), routeSettings);
      case drumKit:
        return _buildRoute(const DrumKitScreen(), routeSettings);
      case xylophone:
        return _buildRoute(const XylophoneScreen(), routeSettings);
      case piano:
        return _buildRoute(const PianoScreen(), routeSettings);
      case electronicPad:
        return _buildRoute(const ElectronicPadScreen(), routeSettings);
      case settings:
        return _buildRoute(const SettingsScreen(), routeSettings);
      default:
        return _buildRoute(const SplashScreen(), routeSettings);
    }
  }

  static PageRouteBuilder _buildRoute(
      Widget page, RouteSettings routeSettings) {
    return PageRouteBuilder(
      settings: routeSettings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 180),
    );
  }
}
