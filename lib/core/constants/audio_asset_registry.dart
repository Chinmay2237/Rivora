import 'package:flutter/foundation.dart';
import 'asset_paths.dart';

enum AudioCategory { drum, xylophone, piano, electronicPad }

enum SoundLoadState { uninitialized, loading, loaded, failed }

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
  // 1. Drums (9 Assets)
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

  // 2. Xylophone Notes (7 Assets)
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

  // 3. Piano Notes (13 Assets - C4 to C5)
  static const AudioAsset pianoC4 = AudioAsset(
    id: 'piano_c4',
    path: 'sounds/piano/c4.wav',
    label: 'C4',
    category: AudioCategory.piano,
  );
  static const AudioAsset pianoCs4 = AudioAsset(
    id: 'piano_cs4',
    path: 'sounds/piano/cs4.wav',
    label: 'C#4',
    category: AudioCategory.piano,
  );
  static const AudioAsset pianoD4 = AudioAsset(
    id: 'piano_d4',
    path: 'sounds/piano/d4.wav',
    label: 'D4',
    category: AudioCategory.piano,
  );
  static const AudioAsset pianoDs4 = AudioAsset(
    id: 'piano_ds4',
    path: 'sounds/piano/ds4.wav',
    label: 'D#4',
    category: AudioCategory.piano,
  );
  static const AudioAsset pianoE4 = AudioAsset(
    id: 'piano_e4',
    path: 'sounds/piano/e4.wav',
    label: 'E4',
    category: AudioCategory.piano,
  );
  static const AudioAsset pianoF4 = AudioAsset(
    id: 'piano_f4',
    path: 'sounds/piano/f4.wav',
    label: 'F4',
    category: AudioCategory.piano,
  );
  static const AudioAsset pianoFs4 = AudioAsset(
    id: 'piano_fs4',
    path: 'sounds/piano/fs4.wav',
    label: 'F#4',
    category: AudioCategory.piano,
  );
  static const AudioAsset pianoG4 = AudioAsset(
    id: 'piano_g4',
    path: 'sounds/piano/g4.wav',
    label: 'G4',
    category: AudioCategory.piano,
  );
  static const AudioAsset pianoGs4 = AudioAsset(
    id: 'piano_gs4',
    path: 'sounds/piano/gs4.wav',
    label: 'G#4',
    category: AudioCategory.piano,
  );
  static const AudioAsset pianoA4 = AudioAsset(
    id: 'piano_a4',
    path: 'sounds/piano/a4.wav',
    label: 'A4',
    category: AudioCategory.piano,
  );
  static const AudioAsset pianoAs4 = AudioAsset(
    id: 'piano_as4',
    path: 'sounds/piano/as4.wav',
    label: 'A#4',
    category: AudioCategory.piano,
  );
  static const AudioAsset pianoB4 = AudioAsset(
    id: 'piano_b4',
    path: 'sounds/piano/b4.wav',
    label: 'B4',
    category: AudioCategory.piano,
  );
  static const AudioAsset pianoC5 = AudioAsset(
    id: 'piano_c5',
    path: 'sounds/piano/c5.wav',
    label: 'C5',
    category: AudioCategory.piano,
  );

  // 4. Electronic Drum Pad Sounds (8 Assets)
  static const AudioAsset padKick = AudioAsset(
    id: 'pad_kick',
    path: AssetPaths.padKick,
    label: '808 Kick',
    category: AudioCategory.electronicPad,
  );
  static const AudioAsset padSnare = AudioAsset(
    id: 'pad_snare',
    path: AssetPaths.padSnare,
    label: 'Trap Snare',
    category: AudioCategory.electronicPad,
  );
  static const AudioAsset padClap = AudioAsset(
    id: 'pad_clap',
    path: AssetPaths.padClap,
    label: 'Hand Clap',
    category: AudioCategory.electronicPad,
  );
  static const AudioAsset padHiHatClosed = AudioAsset(
    id: 'pad_hihat_closed',
    path: AssetPaths.padHiHatClosed,
    label: 'Closed Hat',
    category: AudioCategory.electronicPad,
  );
  static const AudioAsset padHiHatOpen = AudioAsset(
    id: 'pad_hihat_open',
    path: AssetPaths.padHiHatOpen,
    label: 'Open Hat',
    category: AudioCategory.electronicPad,
  );
  static const AudioAsset padTom = AudioAsset(
    id: 'pad_tom',
    path: AssetPaths.padTom,
    label: '808 Tom',
    category: AudioCategory.electronicPad,
  );
  static const AudioAsset padSynthHit = AudioAsset(
    id: 'pad_synth_hit',
    path: AssetPaths.padSynthHit,
    label: 'Synth Stab',
    category: AudioCategory.electronicPad,
  );
  static const AudioAsset padRim = AudioAsset(
    id: 'pad_rim',
    path: AssetPaths.padRim,
    label: 'Rim Shot',
    category: AudioCategory.electronicPad,
  );

  /// All 37 Audio Assets across Rivora
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
        pianoC4,
        pianoCs4,
        pianoD4,
        pianoDs4,
        pianoE4,
        pianoF4,
        pianoFs4,
        pianoG4,
        pianoGs4,
        pianoA4,
        pianoAs4,
        pianoB4,
        pianoC5,
        padKick,
        padSnare,
        padClap,
        padHiHatClosed,
        padHiHatOpen,
        padTom,
        padSynthHit,
        padRim,
      ];

  /// List of all 37 WAV asset paths for preloading into native SoundPool
  static List<String> get allPaths =>
      allAssets.map((asset) => asset.path).toList();
}
