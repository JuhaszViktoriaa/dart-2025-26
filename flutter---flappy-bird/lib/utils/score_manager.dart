import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager {
  static const String _highScoreKey = 'high_score';

  static Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highScoreKey) ?? 0;
  }

  static Future<bool> saveHighScore(int score) async {
    final current = await getHighScore();
    if (score > current) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_highScoreKey, score);
      return true; // new high score
    }
    return false;
  }
}
