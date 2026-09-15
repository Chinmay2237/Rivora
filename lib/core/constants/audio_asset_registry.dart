import 'package:flutter/foundation.dart';
import 'asset_paths.dart';

enum AudioCategory { drum, xylophone }

@immutable
class AudioAsset {
  final String id;
  final String path;
  final String label;
  final AudioCategory category;

  const AudioAsset({
    required this.id,
    required this.path,
    required this.label,
    required this.category,
  });
}

abstract class AudioAssetRegistry {
  // Drums (9 Assets)
  static const AudioAsset kick = AudioAsset(
    id: 'kick',
    path: AssetPaths.soundKick,
    label: 'Kick Drum',
    category: AudioCategory.drum,
  );

  static const AudioAsset snare = AudioAsset(
    id: 'snare',
    path: AssetPaths.soundSnare,
    label: 'Snare Drum',
    category: AudioCategory.drum,
  );

  static const AudioAsset tom1 = AudioAsset(
    id: 'tom1',
    path: AssetPaths.soundTom1,
    label: 'Rack Tom 1',
    category: AudioCategory.drum,
  );

  static const AudioAsset tom2 = AudioAsset(
    id: 'tom2',
    path: AssetPaths.soundTom2,
    label: 'Rack Tom 2',
    category: AudioCategory.drum,
  );

  static const AudioAsset floorTom = AudioAsset(
    id: 'floor_tom',
    path: AssetPaths.soundFloorTom,
    label: 'Floor Tom',
    category: AudioCategory.drum,
  );

  static const AudioAsset hihat = AudioAsset(
    id: 'hihat',
    path: AssetPaths.soundHiHat,
    label: 'Hi-Hat Cymbals',
    category: AudioCategory.drum,
  );

  static const AudioAsset crash = AudioAsset(
    id: 'crash',
    path: AssetPaths.soundCrash,
    label: 'Crash Cymbal',
    category: AudioCategory.drum,
  );

  static const AudioAsset ride = AudioAsset(
    id: 'ride',
    path: AssetPaths.soundRide,
    label: 'Ride Cymbal',
    category: AudioCategory.drum,
  );

  static const AudioAsset splash = AudioAsset(
    id: 'splash',
    path: AssetPaths.soundSplash,
    label: 'Splash Cymbal',
    category: AudioCategory.drum,
  );

  // Xylophone Notes (7 Assets)
  static const AudioAsset xyloNote1 = AudioAsset(
    id: 'xylo_note_1',
    path: 'sounds/xylophone/note1.wav',
    label: 'C (Do)',
    category: AudioCategory.xylophone,
  );

  static const AudioAsset xyloNote2 = AudioAsset(
    id: 'xylo_note_2',
    path: 'sounds/xylophone/note2.wav',
    label: 'D (Re)',
    category: AudioCategory.xylophone,
  );

  static const AudioAsset xyloNote3 = AudioAsset(
    id: 'xylo_note_3',
    path: 'sounds/xylophone/note3.wav',
    label: 'E (Mi)',
    category: AudioCategory.xylophone,
  );

  static const AudioAsset xyloNote4 = AudioAsset(
    id: 'xylo_note_4',
    path: 'sounds/xylophone/note4.wav',
    label: 'F (Fa)',
    category: AudioCategory.xylophone,
  );

  static const AudioAsset xyloNote5 = AudioAsset(
    id: 'xylo_note_5',
    path: 'sounds/xylophone/note5.wav',
    label: 'G (Sol)',
    category: AudioCategory.xylophone,
  );

  static const AudioAsset xyloNote6 = AudioAsset(
    id: 'xylo_note_6',
    path: 'sounds/xylophone/note6.wav',
    label: 'A (La)',
    category: AudioCategory.xylophone,
  );

  static const AudioAsset xyloNote7 = AudioAsset(
    id: 'xylo_note_7',
    path: 'sounds/xylophone/note7.wav',
    label: 'B (Si)',
    category: AudioCategory.xylophone,
  );

  /// All 16 Audio Assets across the entire Rivora app
  static List<AudioAsset> get allAssets => const [
        kick,
        snare,
        tom1,
        tom2,
        floorTom,
        hihat,
        crash,
        ride,
        splash,
        xyloNote1,
        xyloNote2,
        xyloNote3,
        xyloNote4,
        xyloNote5,
        xyloNote6,
        xyloNote7,
      ];

  /// List of all 16 WAV asset paths for preloading into native SoundPool
  static List<String> get allPaths =>
      allAssets.map((asset) => asset.path).toList();

  /// Drum Kit Sound Paths (9)
  static List<String> get drumPaths => const [
        AssetPaths.soundKick,
        AssetPaths.soundSnare,
        AssetPaths.soundTom1,
        AssetPaths.soundTom2,
        AssetPaths.soundFloorTom,
        AssetPaths.soundHiHat,
        AssetPaths.soundCrash,
        AssetPaths.soundRide,
        AssetPaths.soundSplash,
      ];

  /// Xylophone Sound Paths (7)
  static List<String> get xylophonePaths => List.generate(
        7,
        (index) => AssetPaths.xyloNote(index + 1),
      );
}
