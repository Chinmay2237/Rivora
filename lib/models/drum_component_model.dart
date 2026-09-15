import 'package:flutter/foundation.dart';
import '../core/constants/asset_paths.dart';

@immutable
class DrumComponentModel {
  final String id;
  final String name;
  final String semanticLabel;
  final String imageAsset;
  final String soundAsset;
  final String soundName;
  final double relativeLeft;
  final double relativeTop;
  final double relativeWidth;
  final double relativeHeight;
  final int zIndex;

  const DrumComponentModel({
    required this.id,
    required this.name,
    required this.semanticLabel,
    required this.imageAsset,
    required this.soundAsset,
    required this.soundName,
    required this.relativeLeft,
    required this.relativeTop,
    required this.relativeWidth,
    required this.relativeHeight,
    this.zIndex = 1,
  });

  static List<DrumComponentModel> get defaultComponents => const [
        // 1. Bass Drum (Kick) - Large centered anchor in lower-middle stage
        DrumComponentModel(
          id: 'bass_drum',
          name: 'Bass Drum (Kick)',
          semanticLabel: 'Bass drum',
          imageAsset: AssetPaths.drumBass,
          soundAsset: AssetPaths.soundKick,
          soundName: 'kick.wav',
          relativeLeft: 0.28,
          relativeTop: 0.32,
          relativeWidth: 0.44,
          relativeHeight: 0.60,
          zIndex: 2,
        ),
        // 2. Kick Pedal - Center-bottom in front of Kick drum
        DrumComponentModel(
          id: 'kick_pedal',
          name: 'Kick Pedal',
          semanticLabel: 'Kick pedal',
          imageAsset: AssetPaths.drumKickPedal,
          soundAsset: AssetPaths.soundKick,
          soundName: 'kick.wav',
          relativeLeft: 0.42,
          relativeTop: 0.72,
          relativeWidth: 0.16,
          relativeHeight: 0.24,
          zIndex: 4,
        ),
        // 3. Small Rack Tom (Tom 1) - Mounted top-left above Kick drum
        DrumComponentModel(
          id: 'rack_tom_small',
          name: 'Rack Tom 1',
          semanticLabel: 'Small rack tom',
          imageAsset: AssetPaths.drumTomSmall,
          soundAsset: AssetPaths.soundTom1,
          soundName: 'tom_1.wav',
          relativeLeft: 0.28,
          relativeTop: 0.12,
          relativeWidth: 0.22,
          relativeHeight: 0.32,
          zIndex: 3,
        ),
        // 4. Large Rack Tom (Tom 2) - Mounted top-right above Kick drum
        DrumComponentModel(
          id: 'rack_tom_large',
          name: 'Rack Tom 2',
          semanticLabel: 'Large rack tom',
          imageAsset: AssetPaths.drumTomLarge,
          soundAsset: AssetPaths.soundTom2,
          soundName: 'tom_2.wav',
          relativeLeft: 0.50,
          relativeTop: 0.12,
          relativeWidth: 0.23,
          relativeHeight: 0.34,
          zIndex: 3,
        ),
        // 5. Snare Drum - Left foreground, close to drummer
        DrumComponentModel(
          id: 'snare',
          name: 'Snare Drum',
          semanticLabel: 'Snare drum',
          imageAsset: AssetPaths.drumSnare,
          soundAsset: AssetPaths.soundSnare,
          soundName: 'snare.wav',
          relativeLeft: 0.08,
          relativeTop: 0.46,
          relativeWidth: 0.30,
          relativeHeight: 0.42,
          zIndex: 4,
        ),
        // 6. Floor Tom - Right foreground, wide and grounded
        DrumComponentModel(
          id: 'floor_tom',
          name: 'Floor Tom',
          semanticLabel: 'Floor tom',
          imageAsset: AssetPaths.drumFloorTom,
          soundAsset: AssetPaths.soundFloorTom,
          soundName: 'floor_tom.wav',
          relativeLeft: 0.64,
          relativeTop: 0.44,
          relativeWidth: 0.32,
          relativeHeight: 0.46,
          zIndex: 4,
        ),
        // 7. Hi-Hat Cymbals - Left side elevated above Snare
        DrumComponentModel(
          id: 'hi_hat',
          name: 'Hi-Hat Cymbals',
          semanticLabel: 'Hi-hat',
          imageAsset: AssetPaths.drumHiHat,
          soundAsset: AssetPaths.soundHiHat,
          soundName: 'hihat.wav',
          relativeLeft: 0.02,
          relativeTop: 0.18,
          relativeWidth: 0.26,
          relativeHeight: 0.38,
          zIndex: 5,
        ),
        // 8. Crash Cymbal - Upper-left elevated cymbal
        DrumComponentModel(
          id: 'crash',
          name: 'Crash Cymbal',
          semanticLabel: 'Crash cymbal',
          imageAsset: AssetPaths.drumCrash,
          soundAsset: AssetPaths.soundCrash,
          soundName: 'crash.wav',
          relativeLeft: 0.02,
          relativeTop: 0.00,
          relativeWidth: 0.32,
          relativeHeight: 0.32,
          zIndex: 5,
        ),
        // 9. Splash Cymbal - Top-center accent cymbal
        DrumComponentModel(
          id: 'splash',
          name: 'Splash Cymbal',
          semanticLabel: 'Splash cymbal',
          imageAsset: AssetPaths.drumSplash,
          soundAsset: AssetPaths.soundSplash,
          soundName: 'splash.wav',
          relativeLeft: 0.41,
          relativeTop: 0.00,
          relativeWidth: 0.18,
          relativeHeight: 0.22,
          zIndex: 5,
        ),
        // 10. Ride Cymbal - Upper-right elevated cymbal
        DrumComponentModel(
          id: 'ride',
          name: 'Ride Cymbal',
          semanticLabel: 'Ride cymbal',
          imageAsset: AssetPaths.drumRide,
          soundAsset: AssetPaths.soundRide,
          soundName: 'ride.wav',
          relativeLeft: 0.66,
          relativeTop: 0.00,
          relativeWidth: 0.32,
          relativeHeight: 0.34,
          zIndex: 5,
        ),
      ];
}
