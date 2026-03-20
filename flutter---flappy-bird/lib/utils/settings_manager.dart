import 'package:shared_preferences/shared_preferences.dart';

enum Difficulty { easy, normal, hard }

class SettingsManager {
  static const _soundKey = 'sound_enabled';
  static const _musicKey = 'music_enabled';
  static const _difficultyKey = 'difficulty';
  static const _playerNameKey = 'player_name';
  static const _vibrationKey = 'vibration_enabled';

  // ── Getters ──────────────────────────────────────────────────────────────

  static Future<bool> getSoundEnabled() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_soundKey) ?? true;
  }

  static Future<bool> getMusicEnabled() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_musicKey) ?? true;
  }

  static Future<Difficulty> getDifficulty() async {
    final p = await SharedPreferences.getInstance();
    final index = p.getInt(_difficultyKey) ?? 0;
    return Difficulty.values[index.clamp(0, Difficulty.values.length - 1)];
  }

  static Future<String> getPlayerName() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_playerNameKey) ?? 'Player';
  }

  static Future<bool> getVibrationEnabled() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_vibrationKey) ?? true;
  }

  // ── Setters ──────────────────────────────────────────────────────────────

  static Future<void> setSoundEnabled(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_soundKey, v);
  }

  static Future<void> setMusicEnabled(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_musicKey, v);
  }

  static Future<void> setDifficulty(Difficulty d) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_difficultyKey, d.index);
  }

  static Future<void> setPlayerName(String name) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_playerNameKey, name.isEmpty ? 'Player' : name);
  }

  static Future<void> setVibrationEnabled(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_vibrationKey, v);
  }

  // ── Physics multipliers per difficulty ───────────────────────────────────

  static double gravityMultiplier(Difficulty d) {
    switch (d) {
      case Difficulty.easy:   return 0.75;
      case Difficulty.normal: return 1.0;
      case Difficulty.hard:   return 1.35;
    }
  }

  static double speedMultiplier(Difficulty d) {
    switch (d) {
      case Difficulty.easy:   return 0.75;
      case Difficulty.normal: return 1.0;
      case Difficulty.hard:   return 1.4;
    }
  }

  static double gapMultiplier(Difficulty d) {
    switch (d) {
      case Difficulty.easy:   return 1.25;
      case Difficulty.normal: return 1.0;
      case Difficulty.hard:   return 0.75;
    }
  }
}
