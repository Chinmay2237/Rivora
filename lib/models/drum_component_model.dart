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
        // 1. Kick Drum
        DrumComponentModel(
          id: 'bass_drum',
          name: 'Bass Drum (Kick)',
          semanticLabel: 'Bass drum',
          imageAsset: AssetPaths.drumBass,
          soundAsset: AssetPaths.soundKick,
          soundName: 'kick.wav',
          relativeLeft: 0.32,
          relativeTop: 0.52,
          relativeWidth: 0.36,
          relativeHeight: 0.44,
          zIndex: 2,
        ),
        // 2. Kick Pedal
        DrumComponentModel(
          id: 'kick_pedal',
          name: 'Kick Pedal',
          semanticLabel: 'Kick pedal',
          imageAsset: AssetPaths.drumKickPedal,
          soundAsset: AssetPaths.soundKick,
          soundName: 'kick.wav',
          relativeLeft: 0.43,
          relativeTop: 0.80,
          relativeWidth: 0.14,
          relativeHeight: 0.18,
          zIndex: 3,
        ),
        // 3. Snare Drum
        DrumComponentModel(
          id: 'snare',
          name: 'Snare Drum',
          semanticLabel: 'Snare drum',
          imageAsset: AssetPaths.drumSnare,
          soundAsset: AssetPaths.soundSnare,
          soundName: 'snare.wav',
          relativeLeft: 0.18,
          relativeTop: 0.48,
          relativeWidth: 0.28,
          relativeHeight: 0.34,
          zIndex: 4,
        ),
        // 4. Small Rack Tom (Tom 1)
        DrumComponentModel(
          id: 'rack_tom_small',
          name: 'Rack Tom 1',
          semanticLabel: 'Small rack tom',
          imageAsset: AssetPaths.drumTomSmall,
          soundAsset: AssetPaths.soundTom1,
          soundName: 'tom_1.wav',
          relativeLeft: 0.30,
          relativeTop: 0.22,
          relativeWidth: 0.23,
          relativeHeight: 0.28,
          zIndex: 3,
        ),
        // 5. Large Rack Tom (Tom 2)
        DrumComponentModel(
          id: 'rack_tom_large',
          name: 'Rack Tom 2',
          semanticLabel: 'Large rack tom',
          imageAsset: AssetPaths.drumTomLarge,
          soundAsset: AssetPaths.soundTom2,
          soundName: 'tom_2.wav',
          relativeLeft: 0.50,
          relativeTop: 0.22,
          relativeWidth: 0.25,
          relativeHeight: 0.30,
          zIndex: 3,
        ),
        // 6. Floor Tom
        DrumComponentModel(
          id: 'floor_tom',
          name: 'Floor Tom',
          semanticLabel: 'Floor tom',
          imageAsset: AssetPaths.drumFloorTom,
          soundAsset: AssetPaths.soundFloorTom,
          soundName: 'floor_tom.wav',
          relativeLeft: 0.60,
          relativeTop: 0.48,
          relativeWidth: 0.30,
          relativeHeight: 0.38,
          zIndex: 4,
        ),
        // 7. Hi-Hat
        DrumComponentModel(
          id: 'hi_hat',
          name: 'Hi-Hat Cymbals',
          semanticLabel: 'Hi-hat',
          imageAsset: AssetPaths.drumHiHat,
          soundAsset: AssetPaths.soundHiHat,
          soundName: 'hihat.wav',
          relativeLeft: 0.05,
          relativeTop: 0.30,
          relativeWidth: 0.24,
          relativeHeight: 0.35,
          zIndex: 5,
        ),
        // 8. Splash Cymbal
        DrumComponentModel(
          id: 'splash',
          name: 'Splash Cymbal',
          semanticLabel: 'Splash cymbal',
          imageAsset: AssetPaths.drumSplash,
          soundAsset: AssetPaths.soundSplash,
          soundName: 'splash.wav',
          relativeLeft: 0.38,
          relativeTop: 0.05,
          relativeWidth: 0.18,
          relativeHeight: 0.20,
          zIndex: 5,
        ),
        // 9. Crash Cymbal
        DrumComponentModel(
          id: 'crash',
          name: 'Crash Cymbal',
          semanticLabel: 'Crash cymbal',
          imageAsset: AssetPaths.drumCrash,
          soundAsset: AssetPaths.soundCrash,
          soundName: 'crash.wav',
          relativeLeft: 0.08,
          relativeTop: 0.04,
          relativeWidth: 0.30,
          relativeHeight: 0.32,
          zIndex: 5,
        ),
        // 10. Ride Cymbal
        DrumComponentModel(
          id: 'ride',
          name: 'Ride Cymbal',
          semanticLabel: 'Ride cymbal',
          imageAsset: AssetPaths.drumRide,
          soundAsset: AssetPaths.soundRide,
          soundName: 'ride.wav',
          relativeLeft: 0.64,
          relativeTop: 0.05,
          relativeWidth: 0.32,
          relativeHeight: 0.35,
          zIndex: 5,
        ),
      ];
}
