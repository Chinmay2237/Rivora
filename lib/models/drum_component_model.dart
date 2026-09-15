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
        // 1. Bass Drum (Kick) - Main center-low anchor (enlarged visual scale)
        DrumComponentModel(
          id: 'bass_drum',
          name: 'Bass Drum (Kick)',
          semanticLabel: 'Bass drum',
          imageAsset: AssetPaths.drumBass,
          soundAsset: AssetPaths.soundKick,
          soundName: 'kick.wav',
          relativeLeft: 0.24,
          relativeTop: 0.30,
          relativeWidth: 0.52,
          relativeHeight: 0.68,
          zIndex: 2,
        ),
        // 2. Kick Pedal - Placed center-bottom in front of kick (enlarged visual scale)
        DrumComponentModel(
          id: 'kick_pedal',
          name: 'Kick Pedal',
          semanticLabel: 'Kick pedal',
          imageAsset: AssetPaths.drumKickPedal,
          soundAsset: AssetPaths.soundKick,
          soundName: 'kick.wav',
          relativeLeft: 0.41,
          relativeTop: 0.70,
          relativeWidth: 0.18,
          relativeHeight: 0.28,
          zIndex: 4,
        ),
        // 3. Small Rack Tom (Tom 1) - Mounted top-left of Kick (enlarged visual scale)
        DrumComponentModel(
          id: 'rack_tom_small',
          name: 'Rack Tom 1',
          semanticLabel: 'Small rack tom',
          imageAsset: AssetPaths.drumTomSmall,
          soundAsset: AssetPaths.soundTom1,
          soundName: 'tom_1.wav',
          relativeLeft: 0.22,
          relativeTop: 0.08,
          relativeWidth: 0.30,
          relativeHeight: 0.38,
          zIndex: 3,
        ),
        // 4. Large Rack Tom (Tom 2) - Mounted top-right of Kick (enlarged visual scale)
        DrumComponentModel(
          id: 'rack_tom_large',
          name: 'Rack Tom 2',
          semanticLabel: 'Large rack tom',
          imageAsset: AssetPaths.drumTomLarge,
          soundAsset: AssetPaths.soundTom2,
          soundName: 'tom_2.wav',
          relativeLeft: 0.47,
          relativeTop: 0.08,
          relativeWidth: 0.31,
          relativeHeight: 0.40,
          zIndex: 3,
        ),
        // 5. Snare Drum - Left of Kick (enlarged visual scale)
        DrumComponentModel(
          id: 'snare',
          name: 'Snare Drum',
          semanticLabel: 'Snare drum',
          imageAsset: AssetPaths.drumSnare,
          soundAsset: AssetPaths.soundSnare,
          soundName: 'snare.wav',
          relativeLeft: 0.04,
          relativeTop: 0.36,
          relativeWidth: 0.38,
          relativeHeight: 0.48,
          zIndex: 4,
        ),
        // 6. Floor Tom - Right of Kick (enlarged visual scale)
        DrumComponentModel(
          id: 'floor_tom',
          name: 'Floor Tom',
          semanticLabel: 'Floor tom',
          imageAsset: AssetPaths.drumFloorTom,
          soundAsset: AssetPaths.soundFloorTom,
          soundName: 'floor_tom.wav',
          relativeLeft: 0.56,
          relativeTop: 0.34,
          relativeWidth: 0.40,
          relativeHeight: 0.52,
          zIndex: 4,
        ),
        // 7. Hi-Hat - Left side above-left of snare (enlarged visual scale)
        DrumComponentModel(
          id: 'hi_hat',
          name: 'Hi-Hat Cymbals',
          semanticLabel: 'Hi-hat',
          imageAsset: AssetPaths.drumHiHat,
          soundAsset: AssetPaths.soundHiHat,
          soundName: 'hihat.wav',
          relativeLeft: 0.00,
          relativeTop: 0.10,
          relativeWidth: 0.36,
          relativeHeight: 0.48,
          zIndex: 5,
        ),
        // 8. Crash Cymbal - Upper-left cymbal (enlarged visual scale)
        DrumComponentModel(
          id: 'crash',
          name: 'Crash Cymbal',
          semanticLabel: 'Crash cymbal',
          imageAsset: AssetPaths.drumCrash,
          soundAsset: AssetPaths.soundCrash,
          soundName: 'crash.wav',
          relativeLeft: 0.00,
          relativeTop: 0.00,
          relativeWidth: 0.42,
          relativeHeight: 0.44,
          zIndex: 5,
        ),
        // 9. Splash Cymbal - Top-center cymbal (enlarged visual scale)
        DrumComponentModel(
          id: 'splash',
          name: 'Splash Cymbal',
          semanticLabel: 'Splash cymbal',
          imageAsset: AssetPaths.drumSplash,
          soundAsset: AssetPaths.soundSplash,
          soundName: 'splash.wav',
          relativeLeft: 0.375,
          relativeTop: 0.00,
          relativeWidth: 0.25,
          relativeHeight: 0.28,
          zIndex: 5,
        ),
        // 10. Ride Cymbal - Upper-right cymbal (enlarged visual scale)
        DrumComponentModel(
          id: 'ride',
          name: 'Ride Cymbal',
          semanticLabel: 'Ride cymbal',
          imageAsset: AssetPaths.drumRide,
          soundAsset: AssetPaths.soundRide,
          soundName: 'ride.wav',
          relativeLeft: 0.56,
          relativeTop: 0.00,
          relativeWidth: 0.44,
          relativeHeight: 0.46,
          zIndex: 5,
        ),
      ];
}
