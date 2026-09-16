import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Ultra-low latency, zero-disk-I/O polyphonic audio engine for Rivora.
///
/// Uses native Android SoundPool via MethodChannel ('com.example.rivora/audio')
/// on Android, with an instant preloaded AudioPlayer fallback pool for all platforms.
/// Includes high-precision timestamped tracing and robust per-sample error recovery.
class DrumAudioService with WidgetsBindingObserver {
  static final DrumAudioService _instance = DrumAudioService._internal();
  factory DrumAudioService() => _instance;

  DrumAudioService._internal() {
    WidgetsBinding.instance.addObserver(this);
    _stopwatch.start();
    debugPrint('[AudioEngine] Service instance initialized');
  }

  static const MethodChannel _nativeChannel =
      MethodChannel('com.example.rivora/audio');

  final Stopwatch _stopwatch = Stopwatch();

  bool _isMuted = false;
  bool _hapticEnabled = true;
  double _volume = 1.0;

  // Native SoundPool loaded sound ID mappings (Android)
  final Map<String, int> _nativeSoundIds = {};

  // AudioPlayer pool fallback for all platforms (guarantees zero silent taps)
  final List<AudioPlayer> _fallbackPool = [];
  final int _fallbackPoolSize = 8;
  int _fallbackPoolIndex = 0;

  Future<void>? _initFuture;
  bool _isDisposed = false;
  bool _isNativeAvailable = false;

  // Diagnostic Tracing Metrics
  double _lastLatencyMs = 0.0;
  int _totalPlayCount = 0;
  int _successfulPlayCount = 0;
  int _failedPlayCount = 0;
  int _lastStreamId = 0;
  String _lastRequestedSound = '';
  String _lastErrorMessage = 'None';

  bool get isMuted => _isMuted;
  bool get hapticEnabled => _hapticEnabled;
  double get volume => _volume;
  bool get isInitialized => _initFuture != null;
  bool get isNativeAvailable => _isNativeAvailable;
  int get loadedSoundCount => _nativeSoundIds.length;
  double get lastMeasuredLatencyMs => _lastLatencyMs;
  int get totalPlayCount => _totalPlayCount;
  int get successfulPlayCount => _successfulPlayCount;
  int get failedPlayCount => _failedPlayCount;
  int get lastStreamId => _lastStreamId;
  String get lastRequestedSound => _lastRequestedSound;
  String get lastErrorMessage => _lastErrorMessage;
  Map<String, int> get nativeSoundIds => Map.unmodifiable(_nativeSoundIds);

  void toggleMute() {
    _isMuted = !_isMuted;
    debugPrint('[AudioEngine] Mute toggled: $_isMuted');
  }

  void setMute(bool mute) {
    _isMuted = mute;
    debugPrint('[AudioEngine] Mute set to: $_isMuted');
  }

  void toggleHaptic() {
    _hapticEnabled = !_hapticEnabled;
    debugPrint('[AudioEngine] Haptics toggled: $_hapticEnabled');
  }

  void setVolume(double vol) {
    _volume = vol.clamp(0.0, 1.0);
    debugPrint('[AudioEngine] Volume set to: $_volume');
    if (_isNativeAvailable) {
      _nativeChannel
          .invokeMethod('setVolume', {'volume': _volume}).catchError((_) {});
    }
    for (final player in _fallbackPool) {
      player.setVolume(_volume).catchError((_) {});
    }
  }

  /// Idempotent initialization loading assets into native SoundPool memory
  Future<void> initialize(List<String> soundAssets) {
    if (_initFuture != null) return _initFuture!;
    _initFuture = _initializeInternal(soundAssets).catchError((e) {
      _initFuture = null; // Clear cached future on failure so retry is possible
      throw e;
    });
    return _initFuture!;
  }

  Future<void> _initializeInternal(List<String> soundAssets) async {
    final initStart = _stopwatch.elapsedMicroseconds / 1000.0;
    debugPrint(
        '[AudioEngine] Initializing audio engine for ${soundAssets.length} assets...');

    // 1. Initialize Fallback AudioPlayer Pool for instantaneous backup playback
    if (_fallbackPool.isEmpty) {
      for (int i = 0; i < _fallbackPoolSize; i++) {
        try {
          final player = AudioPlayer();
          await player.setPlayerMode(PlayerMode.lowLatency);
          await player.setVolume(_volume);
          _fallbackPool.add(player);
        } catch (_) {
          final fallbackPlayer = AudioPlayer();
          await fallbackPlayer.setVolume(_volume);
          _fallbackPool.add(fallbackPlayer);
        }
      }
      debugPrint(
          '[AudioEngine Fallback] Pre-created ${_fallbackPool.length} AudioPlayers');
    }

    // 2. Native Android SoundPool Preloading
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        final Map<dynamic, dynamic>? res = await _nativeChannel
            .invokeMethod<Map<dynamic, dynamic>>('preloadAll', {
          'assetPaths': soundAssets,
        });

        if (res != null) {
          res.forEach((key, val) {
            if (key is String && val is int && val > 0) {
              _nativeSoundIds[key] = val;
            }
          });
          debugPrint(
              '[AudioEngine Native] Preloaded ${_nativeSoundIds.length}/${soundAssets.length} assets');
        }

        // Wait for native OnLoadCompleteListener to confirm sample readiness
        int readyCount = 0;
        for (int attempt = 0; attempt < 25; attempt++) {
          final diag = await getNativeDiagnosticState();
          readyCount = (diag['readyCount'] as int?) ?? 0;
          if (readyCount >= _nativeSoundIds.length && readyCount > 0) {
            break;
          }
          await Future.delayed(const Duration(milliseconds: 100));
        }

        _isNativeAvailable = readyCount > 0;
        if (_isNativeAvailable) {
          _lastErrorMessage = 'None';
          debugPrint(
              '[AudioEngine Native SUCCESS] Native SoundPool active with $readyCount ready samples!');
        } else {
          _lastErrorMessage = 'Native samples count ($readyCount) below target (${soundAssets.length})';
          debugPrint('[AudioEngine Native WARNING] $_lastErrorMessage');
        }
      } catch (e) {
        debugPrint(
            '[AudioEngine Native ERROR] Native SoundPool initialization failed: $e');
        _isNativeAvailable = false;
        _lastErrorMessage = 'Native initialization failed: $e';
      }
    }

    final initEnd = _stopwatch.elapsedMicroseconds / 1000.0;
    debugPrint(
        '[AudioEngine] Engine initialized in ${(initEnd - initStart).toStringAsFixed(2)} ms. Native SoundPool: $_isNativeAvailable');
  }

  /// Query native Java SoundPool diagnostic state map
  Future<Map<String, dynamic>> getNativeDiagnosticState() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return {'nativeAvailable': false, 'reason': 'Platform is not Android'};
    }
    try {
      final res = await _nativeChannel
          .invokeMapMethod<String, dynamic>('getDiagnosticState');
      return res ?? {'error': 'Null response'};
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Immediate, ultra-low latency sound playback trigger.
  void playSound(String soundAsset, {double? pointerDownMs}) {
    if (_isMuted || _isDisposed) return;

    final requestMs = _stopwatch.elapsedMicroseconds / 1000.0;
    _totalPlayCount++;
    _lastRequestedSound = soundAsset;

    if (_hapticEnabled) {
      HapticFeedback.lightImpact().catchError((_) {});
    }

    if (pointerDownMs != null) {
      debugPrint(
          '[AudioTrace] pointerDown: ${pointerDownMs.toStringAsFixed(2)}ms | soundRequested: ${requestMs.toStringAsFixed(2)}ms');
    }

    if (_isNativeAvailable && _nativeSoundIds.containsKey(soundAsset)) {
      // 1. Native SoundPool Path (< 2ms hardware execution)
      final playStart = _stopwatch.elapsedMicroseconds / 1000.0;
      _nativeChannel.invokeMethod<int>('play', {
        'assetPath': soundAsset,
        'volume': _volume,
      }).then((streamId) {
        final playEnd = _stopwatch.elapsedMicroseconds / 1000.0;
        _lastLatencyMs = playEnd - playStart;
        if (streamId != null && streamId > 0) {
          _successfulPlayCount++;
          _lastStreamId = streamId;
          debugPrint(
              '[AudioTrace Native] soundAsset: $soundAsset | soundId: ${_nativeSoundIds[soundAsset]} | streamId: $streamId | latency: ${_lastLatencyMs.toStringAsFixed(2)}ms');
        } else {
          // Native streamId == 0 (e.g. unready or busy) -> Fallback seamlessly!
          _lastErrorMessage = 'Stream ID 0 returned for $soundAsset - Using AudioPlayer fallback';
          debugPrint('[AudioTrace Native Fallback] streamId is 0 for asset $soundAsset, invoking AudioPlayer fallback');
          _playFallbackAsset(soundAsset, requestMs);
        }
      }).catchError((e) {
        // Native invocation error -> Fallback seamlessly!
        _lastErrorMessage = 'Native play error: $e - Using AudioPlayer fallback';
        debugPrint('[AudioTrace Native Error Fallback] Error for $soundAsset: $e, invoking AudioPlayer fallback');
        _playFallbackAsset(soundAsset, requestMs);
      });
    } else {
      // 2. Direct Fallback Path for non-Android or unready native assets
      _playFallbackAsset(soundAsset, requestMs);
    }
  }

  void _playFallbackAsset(String soundAsset, double requestMs) {
    if (_fallbackPool.isNotEmpty) {
      final player = _fallbackPool[_fallbackPoolIndex];
      _fallbackPoolIndex = (_fallbackPoolIndex + 1) % _fallbackPool.length;

      final playStart = _stopwatch.elapsedMicroseconds / 1000.0;
      player.play(AssetSource(soundAsset), volume: _volume).then((_) {
        final playEnd = _stopwatch.elapsedMicroseconds / 1000.0;
        _lastLatencyMs = playEnd - playStart;
        _successfulPlayCount++;
        debugPrint(
            '[AudioTrace Fallback Pool] soundAsset: $soundAsset | latency: ${_lastLatencyMs.toStringAsFixed(2)}ms');
      }).catchError((e) {
        _failedPlayCount++;
        _lastErrorMessage = 'Fallback error: $e';
        debugPrint('[AudioTrace ERROR] Fallback play error: $e');
      });
    } else {
      final player = AudioPlayer();
      player.play(AssetSource(soundAsset), volume: _volume).then((_) {
        _successfulPlayCount++;
        player.onPlayerComplete.first.then((_) => player.dispose());
      }).catchError((e) {
        _failedPlayCount++;
        _lastErrorMessage = 'One-shot fallback error: $e';
      });
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
    if (_isNativeAvailable) {
      _nativeChannel.invokeMethod('stopAll').catchError((_) {});
    }
    for (final player in _fallbackPool) {
      player.stop().catchError((_) {});
    }
  }

  void dispose() {
    if (_isDisposed) return;
    debugPrint('[AudioEngine] Disposing DrumAudioService');
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);

    _stopAll();
    for (final player in _fallbackPool) {
      player.dispose().catchError((_) {});
    }
    _fallbackPool.clear();
    _nativeSoundIds.clear();
    _initFuture = null;
  }
}

