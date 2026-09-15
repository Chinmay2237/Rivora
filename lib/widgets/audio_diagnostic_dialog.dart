import 'package:flutter/material.dart';
import '../services/drum_audio_service.dart';
import '../core/constants/asset_paths.dart';
import '../app/app_theme.dart';

class AudioDiagnosticDialog extends StatefulWidget {
  final DrumAudioService audioService;

  const AudioDiagnosticDialog({
    super.key,
    required this.audioService,
  });

  static void show(BuildContext context, DrumAudioService audioService) {
    showDialog(
      context: context,
      builder: (context) => AudioDiagnosticDialog(audioService: audioService),
    );
  }

  @override
  State<AudioDiagnosticDialog> createState() => _AudioDiagnosticDialogState();
}

class _AudioDiagnosticDialogState extends State<AudioDiagnosticDialog> {
  Map<String, dynamic>? _nativeState;
  bool _isLoadingNative = true;

  @override
  void initState() {
    super.initState();
    _fetchNativeState();
  }

  Future<void> _fetchNativeState() async {
    final state = await widget.audioService.getNativeDiagnosticState();
    if (mounted) {
      setState(() {
        _nativeState = state;
        _isLoadingNative = false;
      });
    }
  }

  void _triggerTestSound(String assetPath) {
    final nowMs = DateTime.now().millisecondsSinceEpoch.toDouble();
    widget.audioService.playSound(assetPath, pointerDownMs: nowMs);
    Future.delayed(const Duration(milliseconds: 100), () {
      _fetchNativeState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isNative = widget.audioService.isNativeAvailable;
    final totalPlays = widget.audioService.totalPlayCount;
    final successPlays = widget.audioService.successfulPlayCount;
    final lastLatency = widget.audioService.lastMeasuredLatencyMs;
    final lastStreamId = widget.audioService.lastStreamId;
    final lastError = widget.audioService.lastErrorMessage;
    final lastRequested = widget.audioService.lastRequestedSound;

    final readyCount = (_nativeState?['readyCount'] as int?) ?? 0;
    final failedCount = (_nativeState?['failedCount'] as int?) ?? 0;
    final totalPreloaded = (_nativeState?['totalPreloaded'] as int?) ?? 0;

    final allAssets = [
      // Drums (9)
      {'name': 'Kick', 'asset': AssetPaths.soundKick},
      {'name': 'Snare', 'asset': AssetPaths.soundSnare},
      {'name': 'Tom 1', 'asset': AssetPaths.soundTom1},
      {'name': 'Tom 2', 'asset': AssetPaths.soundTom2},
      {'name': 'Floor Tom', 'asset': AssetPaths.soundFloorTom},
      {'name': 'Hi-Hat', 'asset': AssetPaths.soundHiHat},
      {'name': 'Crash', 'asset': AssetPaths.soundCrash},
      {'name': 'Ride', 'asset': AssetPaths.soundRide},
      {'name': 'Splash', 'asset': AssetPaths.soundSplash},
      // Xylophone (7)
      {'name': 'Xylo C', 'asset': AssetPaths.xyloNote(1)},
      {'name': 'Xylo D', 'asset': AssetPaths.xyloNote(2)},
      {'name': 'Xylo E', 'asset': AssetPaths.xyloNote(3)},
      {'name': 'Xylo F', 'asset': AssetPaths.xyloNote(4)},
      {'name': 'Xylo G', 'asset': AssetPaths.xyloNote(5)},
      {'name': 'Xylo A', 'asset': AssetPaths.xyloNote(6)},
      {'name': 'Xylo B', 'asset': AssetPaths.xyloNote(7)},
    ];

    return Dialog(
      backgroundColor: AppTheme.surfacePrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 660, maxHeight: 540),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.bug_report_rounded,
                    color: AppTheme.accentViolet, size: 24),
                const SizedBox(width: 10),
                const Text(
                  'Audio Engine Diagnostics',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: AppTheme.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: AppTheme.surfaceSecondary, height: 20),

            // Status Badges Row 1
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatusBadge(
                  label: 'Engine',
                  value: isNative ? 'Native SoundPool' : 'AudioPlayer Fallback',
                  isSuccess: isNative,
                ),
                _StatusBadge(
                  label: 'Native Ready',
                  value: '$readyCount / 16',
                  isSuccess: readyCount == 16,
                ),
                _StatusBadge(
                  label: 'Failed Assets',
                  value: '$failedCount',
                  isSuccess: failedCount == 0,
                ),
                _StatusBadge(
                  label: 'Method Latency',
                  value: '${lastLatency.toStringAsFixed(2)} ms',
                  isSuccess: lastLatency < 10,
                ),
                _StatusBadge(
                  label: 'Last StreamID',
                  value: lastStreamId > 0 ? '#$lastStreamId' : 'None',
                  isSuccess: lastStreamId > 0,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Metadata / Tracing Info
            Text(
              'Last Requested: ${lastRequested.isEmpty ? "None" : lastRequested} | Successful Plays: $successPlays / $totalPlays',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),

            if (lastError != 'None') ...[
              const SizedBox(height: 6),
              Text(
                'Last Error: $lastError',
                style: const TextStyle(
                  color: AppTheme.errorRed,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const SizedBox(height: 14),
            const Text(
              'Direct Test Sound Triggers (Manual Sound Pool Verification):',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // Test Buttons Grid
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: allAssets.map((item) {
                    final name = item['name']!;
                    final asset = item['asset']!;

                    bool isReady = true;
                    if (_nativeState != null &&
                        _nativeState!['samples'] != null) {
                      final samplesMap =
                          _nativeState!['samples'] as Map<dynamic, dynamic>?;
                      if (samplesMap != null && samplesMap.containsKey(asset)) {
                        final sampleInfo = samplesMap[asset] as Map?;
                        isReady = sampleInfo?['isReady'] == true;
                      }
                    }

                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.surfaceSecondary,
                        foregroundColor: isReady
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        side: BorderSide(
                          color: isReady
                              ? AppTheme.accentViolet.withValues(alpha: 0.4)
                              : AppTheme.borderSubtle,
                        ),
                      ),
                      icon: Icon(
                        isReady
                            ? Icons.play_arrow_rounded
                            : Icons.hourglass_empty_rounded,
                        size: 16,
                        color: isReady
                            ? AppTheme.successGreen
                            : AppTheme.errorRed,
                      ),
                      label: Text(
                        name,
                        style: const TextStyle(fontSize: 12),
                      ),
                      onPressed: () => _triggerTestSound(asset),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                if (_isLoadingNative)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Text(
                    'Preloaded $totalPreloaded / 16 canonical assets',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: _fetchNativeState,
                  child: const Text('Refresh Status'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final String value;
  final bool isSuccess;

  const _StatusBadge({
    required this.label,
    required this.value,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSuccess ? AppTheme.successGreen : AppTheme.accentViolet,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isSuccess ? AppTheme.successGreen : AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
