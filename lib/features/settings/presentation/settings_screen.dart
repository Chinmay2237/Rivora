import 'package:flutter/material.dart';
import '../../../app/app_theme.dart';
import '../../../app/app_constants.dart';
import '../../../services/drum_audio_service.dart';
import '../../../core/constants/asset_paths.dart';
import '../../../widgets/audio_diagnostic_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final DrumAudioService _audioService = DrumAudioService();
  bool _visualEffectsEnabled = true;
  bool _showLabels = true;
  bool _showNoteNames = true;

  void _restoreDefaults() {
    setState(() {
      _audioService.setMute(false);
      if (!_audioService.hapticEnabled) {
        _audioService.toggleHaptic();
      }
      _audioService.setVolume(1.0);
      _visualEffectsEnabled = true;
      _showLabels = true;
      _showNoteNames = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings restored to defaults'),
        duration: Duration(seconds: 2),
        backgroundColor: AppTheme.surfaceSecondary,
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfacePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        title: Row(
          children: [
            Image.asset(
              AssetPaths.rivoraSymbol,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentViolet,
                ),
                child: const Icon(
                  Icons.graphic_eq_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              AppConstants.appName,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '${AppConstants.appName} v${AppConstants.appVersion}',
              style: TextStyle(
                color: AppTheme.accentHighlight,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'A production-grade mobile music studio featuring 4 playable instruments: Acoustic Drum Kit, Acoustic Xylophone, Grand Piano, and Electronic Drum Pad.',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppTheme.accentViolet),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.8),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.surfacePrimary,
        leading: Semantics(
          button: true,
          label: 'Back',
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              // Section 1: Audio & Controls
              _buildSectionHeader('AUDIO & CONTROLS'),
              _buildSwitchTile(
                title: 'Audio Enabled',
                subtitle: 'Toggle master sound output',
                icon: Icons.volume_up_rounded,
                value: !_audioService.isMuted,
                onChanged: (val) {
                  setState(() {
                    _audioService.setMute(!val);
                  });
                },
              ),
              _buildSwitchTile(
                title: 'Haptic Feedback',
                subtitle: 'Vibrate device on instrument impact',
                icon: Icons.vibration_rounded,
                value: _audioService.hapticEnabled,
                onChanged: (val) {
                  setState(() {
                    _audioService.toggleHaptic();
                  });
                },
              ),
              _buildSwitchTile(
                title: 'Visual Tap Effects',
                subtitle: 'Show glow highlight on instrument press',
                icon: Icons.auto_awesome_rounded,
                value: _visualEffectsEnabled,
                onChanged: (val) {
                  setState(() {
                    _visualEffectsEnabled = val;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Section 2: Instrument Preferences
              _buildSectionHeader('INSTRUMENT PREFERENCES'),
              _buildSwitchTile(
                title: 'Show Instrument Labels',
                subtitle: 'Display names on drum kit pieces',
                icon: Icons.label_rounded,
                value: _showLabels,
                onChanged: (val) {
                  setState(() {
                    _showLabels = val;
                  });
                },
              ),
              _buildSwitchTile(
                title: 'Show Note Names',
                subtitle: 'Display pitch names on keyboard keys',
                icon: Icons.music_note_rounded,
                value: _showNoteNames,
                onChanged: (val) {
                  setState(() {
                    _showNoteNames = val;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Section 3: Developer & Diagnostics
              _buildSectionHeader('DEVELOPER & DIAGNOSTICS'),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                ),
                tileColor: AppTheme.surfacePrimary,
                leading: const Icon(Icons.bug_report_rounded,
                    color: AppTheme.accentViolet),
                title: const Text(
                  'Developer Audio Diagnostics',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'Inspect native SoundPool & fallback state (37 assets)',
                  style:
                      TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: AppTheme.textSecondary),
                onTap: () {
                  AudioDiagnosticDialog.show(context, _audioService);
                },
              ),

              const SizedBox(height: 20),

              // Section 4: Application & About
              _buildSectionHeader('ABOUT RIVORA'),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                ),
                tileColor: AppTheme.surfacePrimary,
                leading: const Icon(Icons.info_outline_rounded,
                    color: AppTheme.accentViolet),
                title: const Text(
                  'About ${AppConstants.appName}',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'Version ${AppConstants.appVersion}',
                  style:
                      TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: AppTheme.textSecondary),
                onTap: _showAboutDialog,
              ),
              const SizedBox(height: 10),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                ),
                tileColor: AppTheme.surfacePrimary,
                leading: const Icon(Icons.restore_rounded,
                    color: AppTheme.accentHighlight),
                title: const Text(
                  'Restore Default Settings',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: _restoreDefaults,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.accentViolet,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfacePrimary,
        borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
      ),
      child: SwitchListTile(
        activeTrackColor: AppTheme.accentViolet,
        secondary: Icon(icon, color: AppTheme.accentViolet),
        title: Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
