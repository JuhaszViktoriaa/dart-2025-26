import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

class StorageService {
  static const String _statsKey = 'game_stats';
  static const String _scoresKey = 'high_scores';
  static const String _settingsKey = 'settings';

  Future<GameStats> loadStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_statsKey);
      if (json == null) return GameStats();
      return GameStats.fromJson(jsonDecode(json));
    } catch (_) {
      return GameStats();
    }
  }

  Future<void> saveStats(GameStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode(stats.toJson()));
  }

  Future<List<ScoreEntry>> loadHighScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_scoresKey);
      if (json == null) return [];
      final list = jsonDecode(json) as List;
      return list.map((e) => ScoreEntry.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveHighScore(ScoreEntry entry) async {
    final scores = await loadHighScores();
    scores.add(entry);
    scores.sort((a, b) => b.score.compareTo(a.score));
    final top10 = scores.take(10).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scoresKey, jsonEncode(top10.map((e) => e.toJson()).toList()));
  }

  Future<Map<String, dynamic>> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_settingsKey);
      if (json == null) return _defaultSettings;
      final loaded = jsonDecode(json) as Map<String, dynamic>;
      return {..._defaultSettings, ...loaded};
    } catch (_) {
      return _defaultSettings;
    }
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings));
  }

  static Map<String, dynamic> get _defaultSettings => {
    'soundEnabled': true,
    'showHints': true,
    'animationsEnabled': true,
    'selectedLayout': 'Classic',
  };

  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_statsKey);
    await prefs.remove(_scoresKey);
  }
}