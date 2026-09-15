abstract class AssetPaths {
  // Rivora Branding & Logos
  static const String splashScreen = 'assets/branding/splash_screen.png';
  static const String appIcon = 'assets/branding/app_icon.png';
  static const String rivoraSymbol = 'assets/branding/rivora_symbol.png';
  static const String rivoraSplashLogo = 'assets/splash/rivora_splash_logo.png';

  // Drum Images
  static const String drumBass = 'assets/images/drum_kit/bass_drum.png';
  static const String drumSnare = 'assets/images/drum_kit/snare.png';
  static const String drumTomSmall =
      'assets/images/drum_kit/rack_tom_small.png';
  static const String drumTomLarge =
      'assets/images/drum_kit/rack_tom_large.png';
  static const String drumFloorTom = 'assets/images/drum_kit/floor_tom.png';
  static const String drumHiHat = 'assets/images/drum_kit/hi_hat.png';
  static const String drumCrash = 'assets/images/drum_kit/crash.png';
  static const String drumRide = 'assets/images/drum_kit/ride.png';
  static const String drumSplash = 'assets/images/drum_kit/splash.png';
  static const String drumKickPedal = 'assets/images/drum_kit/kick_pedal.png';

  // Drum Sounds (9)
  static const String soundKick = 'sounds/drum_kit/kick.wav';
  static const String soundSnare = 'sounds/drum_kit/snare.wav';
  static const String soundTom1 = 'sounds/drum_kit/tom_1.wav';
  static const String soundTom2 = 'sounds/drum_kit/tom_2.wav';
  static const String soundFloorTom = 'sounds/drum_kit/floor_tom.wav';
  static const String soundHiHat = 'sounds/drum_kit/hihat.wav';
  static const String soundCrash = 'sounds/drum_kit/crash.wav';
  static const String soundRide = 'sounds/drum_kit/ride.wav';
  static const String soundSplash = 'sounds/drum_kit/splash.wav';

  // Xylophone Sounds (7)
  static String xyloNote(int noteNumber) =>
      'sounds/xylophone/note$noteNumber.wav';

  // Piano Sounds (13)
  static String pianoNote(String noteKey) => 'sounds/piano/$noteKey.wav';

  // Electronic Pad Sounds (8)
  static const String padKick = 'sounds/pad/elec_kick.wav';
  static const String padSnare = 'sounds/pad/elec_snare.wav';
  static const String padClap = 'sounds/pad/elec_clap.wav';
  static const String padHiHatClosed = 'sounds/pad/elec_hihat_closed.wav';
  static const String padHiHatOpen = 'sounds/pad/elec_hihat_open.wav';
  static const String padTom = 'sounds/pad/elec_tom.wav';
  static const String padSynthHit = 'sounds/pad/elec_synth_hit.wav';
  static const String padRim = 'sounds/pad/elec_rim.wav';
}
