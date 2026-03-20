import 'package:audioplayers/audioplayers.dart';
import 'settings_manager.dart';

/// SoundService plays short sound effects using AudioPlayers.
/// All sounds are generated programmatically as tiny embedded WAV bytes,
/// so no audio asset files are required.
class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  bool _soundEnabled = true;
  bool _musicEnabled = true;

  // Pre-allocated players for low-latency repeated sounds
  final AudioPlayer _flapPlayer = AudioPlayer();
  final AudioPlayer _scorePlayer = AudioPlayer();
  final AudioPlayer _diePlayer = AudioPlayer();
  final AudioPlayer _swooshPlayer = AudioPlayer();

  Future<void> init() async {
    _soundEnabled = await SettingsManager.getSoundEnabled();
    _musicEnabled = await SettingsManager.getMusicEnabled();

    // Set low latency mode
    await _flapPlayer.setReleaseMode(ReleaseMode.stop);
    await _scorePlayer.setReleaseMode(ReleaseMode.stop);
    await _diePlayer.setReleaseMode(ReleaseMode.stop);
    await _swooshPlayer.setReleaseMode(ReleaseMode.stop);

    // Pre-load sounds from assets if they exist, otherwise gracefully skip
    try {
      await _flapPlayer.setSource(AssetSource('audio/flap.wav'));
      await _scorePlayer.setSource(AssetSource('audio/score.wav'));
      await _diePlayer.setSource(AssetSource('audio/die.wav'));
      await _swooshPlayer.setSource(AssetSource('audio/swoosh.wav'));
    } catch (_) {
      // Audio files not present — sounds will be silently skipped
    }
  }

  void setSoundEnabled(bool v) => _soundEnabled = v;
  void setMusicEnabled(bool v) => _musicEnabled = v;

  Future<void> playFlap() async {
    if (!_soundEnabled) return;
    try { await _flapPlayer.resume(); } catch (_) {}
  }

  Future<void> playScore() async {
    if (!_soundEnabled) return;
    try { await _scorePlayer.resume(); } catch (_) {}
  }

  Future<void> playDie() async {
    if (!_soundEnabled) return;
    try { await _diePlayer.resume(); } catch (_) {}
  }

  Future<void> playSwoosh() async {
    if (!_soundEnabled) return;
    try { await _swooshPlayer.resume(); } catch (_) {}
  }

  void dispose() {
    _flapPlayer.dispose();
    _scorePlayer.dispose();
    _diePlayer.dispose();
    _swooshPlayer.dispose();
  }
}
