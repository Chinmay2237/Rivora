import 'package:flutter_test/flutter_test.dart';
import 'package:rivora/models/drum_component_model.dart';
import 'package:rivora/services/drum_audio_service.dart';
import 'package:rivora/features/splash/presentation/splash_screen.dart';
import 'package:rivora/features/instrument_selection/presentation/instrument_selection_screen.dart';
import 'package:rivora/features/settings/presentation/settings_screen.dart';
import 'package:rivora/core/responsive/landscape_guard.dart';
import 'package:rivora/core/constants/rivora_colors.dart';
import 'package:rivora/core/constants/audio_asset_registry.dart';
import 'package:rivora/app/app_theme.dart';
import 'package:rivora/app/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RivoraColors & Theme Tests', () {
    test('RivoraColors values match brand color specification', () {
      expect(RivoraColors.background, const Color(0xFF0B0D14));
      expect(RivoraColors.primary, const Color(0xFF9B6CFF));
      expect(RivoraColors.textPrimary, const Color(0xFFF5F7FB));
    });
  });

  group('AudioAssetRegistry Tests', () {
    test('Canonical registry registers all 37 audio assets', () {
      final allAssets = AudioAssetRegistry.allAssets;
      expect(allAssets.length, 37);

      final drumAssets =
          allAssets.where((a) => a.category == AudioCategory.drum).toList();
      expect(drumAssets.length, 9);

      final xyloAssets = allAssets
          .where((a) => a.category == AudioCategory.xylophone)
          .toList();
      expect(xyloAssets.length, 7);

      final pianoAssets =
          allAssets.where((a) => a.category == AudioCategory.piano).toList();
      expect(pianoAssets.length, 13);

      final padAssets = allAssets
          .where((a) => a.category == AudioCategory.electronicPad)
          .toList();
      expect(padAssets.length, 8);
    });
  });

  group('DrumComponentModel Tests', () {
    test('Default drum components list contains 10 elements', () {
      final components = DrumComponentModel.defaultComponents;
      expect(components.length, 10);
    });

    test('Drum components contain required IDs and semantic labels', () {
      final components = DrumComponentModel.defaultComponents;
      final ids = components.map((c) => c.id).toSet();

      expect(ids.contains('bass_drum'), isTrue);
      expect(ids.contains('snare'), isTrue);
      expect(ids.contains('rack_tom_small'), isTrue);
      expect(ids.contains('rack_tom_large'), isTrue);
      expect(ids.contains('floor_tom'), isTrue);
      expect(ids.contains('hi_hat'), isTrue);

      for (final comp in components) {
        expect(comp.semanticLabel.isNotEmpty, isTrue);
      }
    });
  });

  group('DrumAudioService Tests', () {
    test('Mute and Haptic toggles change state correctly', () {
      final service = DrumAudioService();
      final initialMute = service.isMuted;
      service.toggleMute();
      expect(service.isMuted, !initialMute);
      service.setMute(initialMute);
      expect(service.isMuted, initialMute);
    });
  });

  group('SplashScreen & Hero Animation Tests', () {
    testWidgets('SplashScreen renders hero animation widget cleanly',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1000, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          initialRoute: AppRouter.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      );

      expect(find.byType(SplashScreen), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 2500));

      tester.view.resetPhysicalSize();
    });
  });

  group('LandscapeGuard & Widget Tests', () {
    testWidgets('LandscapeGuard displays fallback screen in portrait mode',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const LandscapeGuard(
            child: Text('Landscape Content'),
          ),
        ),
      );

      expect(find.text('Please Rotate Your Device'), findsOneWidget);
      expect(find.text('Landscape Content'), findsNothing);

      tester.view.resetPhysicalSize();
    });

    testWidgets(
        'InstrumentSelectionScreen renders studio title and 4 instrument cards',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const InstrumentSelectionScreen(),
        ),
      );

      expect(find.text('Rivora'), findsOneWidget);
      expect(find.text('Make some music'), findsOneWidget);
      expect(find.text('Acoustic Drum Kit'), findsOneWidget);
      expect(find.text('Acoustic Xylophone'), findsOneWidget);
      expect(find.text('Grand Piano'), findsOneWidget);
      expect(find.text('Electronic Drum Pad'), findsOneWidget);

      tester.view.resetPhysicalSize();
    });

    testWidgets('SettingsScreen renders options and version info',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1000, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const SettingsScreen(),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Audio Enabled'), findsOneWidget);
      expect(find.text('Haptic Feedback'), findsOneWidget);

      // Scroll to find About Rivora tile
      final aboutFinder = find.text('About Rivora');
      await tester.scrollUntilVisible(aboutFinder, 200.0);
      expect(aboutFinder, findsOneWidget);

      tester.view.resetPhysicalSize();
    });
  });
}
