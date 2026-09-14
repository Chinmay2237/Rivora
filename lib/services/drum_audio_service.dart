import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class DrumAudioService with WidgetsBindingObserver {
  static final DrumAudioService _instance = DrumAudioService._internal();
  factory DrumAudioService() => _instance;

  DrumAudioService._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  bool _isMuted = false;
  bool _hapticEnabled = true;
  double _volume = 1.0;

  final Map<String, List<AudioPlayer>> _playerPools = {};
  final Map<String, int> _poolIndex = {};
  final int _poolSizePerSound = 3;

  Future<void>? _initFuture;
  bool _isDisposed = false;

  bool get isMuted => _isMuted;
  bool get hapticEnabled => _hapticEnabled;
  double get volume => _volume;
  bool get isInitialized => _initFuture != null;

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  void setMute(bool mute) {
    _isMuted = mute;
  }

  void toggleHaptic() {
    _hapticEnabled = !_hapticEnabled;
  }

  void setVolume(double vol) {
    _volume = vol.clamp(0.0, 1.0);
    _playerPools.forEach((_, pool) {
      for (final player in pool) {
        player.setVolume(_volume).catchError((_) {});
      }
    });
  }

  /// Idempotent initialization guarding against race conditions
  Future<void> initialize(List<String> soundAssets) {
    _initFuture ??= _initializeInternal(soundAssets);
    return _initFuture!;
  }

  Future<void> _initializeInternal(List<String> soundAssets) async {
    for (final soundAsset in soundAssets) {
      if (_isDisposed) break;
      _playerPools[soundAsset] = [];
      _poolIndex[soundAsset] = 0;

      for (int i = 0; i < _poolSizePerSound; i++) {
        try {
          final player = AudioPlayer();
          await player.setPlayerMode(PlayerMode.lowLatency);
          await player.setVolume(_volume);
          _playerPools[soundAsset]!.add(player);
        } catch (e) {
          debugPrint(
              'DrumAudioService: Error preloading $soundAsset player $i: $e');
        }
      }
    }
  }

  Future<void> playSound(String soundAsset) async {
    if (_isMuted || _isDisposed) return;

    if (_hapticEnabled) {
      HapticFeedback.lightImpact().catchError((_) {});
    }

    final pool = _playerPools[soundAsset];
    if (pool != null && pool.isNotEmpty) {
      final index = _poolIndex[soundAsset] ?? 0;
      final player = pool[index];
      _poolIndex[soundAsset] = (index + 1) % pool.length;

      try {
        await player.stop();
        await player.play(AssetSource(soundAsset), volume: _volume);
      } catch (e) {
        debugPrint('DrumAudioService: Error playing $soundAsset: $e');
      }
    } else {
      // Defensive fallback for un-pooled assets
      try {
        final tempPlayer = AudioPlayer();
        await tempPlayer.play(AssetSource(soundAsset), volume: _volume);
      } catch (e) {
        debugPrint('DrumAudioService: Fallback error playing $soundAsset: $e');
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _stopAll();
    }
  }

  void _stopAll() {
    _playerPools.forEach((_, pool) {
      for (final player in pool) {
        player.stop().catchError((_) {});
      }
    });
  }

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);

    _stopAll();
    _playerPools.forEach((_, pool) {
      for (final player in pool) {
        player.dispose().catchError((_) {});
      }
    });
    _playerPools.clear();
    _poolIndex.clear();
    _initFuture = null;
  }
}
