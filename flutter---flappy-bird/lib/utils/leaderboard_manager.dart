import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardEntry {
  final String name;
  final int score;
  final DateTime date;

  LeaderboardEntry({
    required this.name,
    required this.score,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
        'date': date.toIso8601String(),
      };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      LeaderboardEntry(
        name: json['name'] as String? ?? 'Player',
        score: json['score'] as int? ?? 0,
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      );
}

class LeaderboardManager {
  static const _key = 'leaderboard_v1';
  static const int maxEntries = 10;

  static Future<List<LeaderboardEntry>> getEntries() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));
    } catch (_) {
      return [];
    }
  }

  /// Returns the rank (1-based) if the score made it to the board, else null.
  static Future<int?> addEntry(String name, int score) async {
    final entries = await getEntries();
    final newEntry = LeaderboardEntry(
      name: name.isEmpty ? 'Player' : name,
      score: score,
      date: DateTime.now(),
    );
    entries.add(newEntry);
    entries.sort((a, b) => b.score.compareTo(a.score));

    final rank = entries.indexOf(newEntry) + 1;

    // Keep only top N
    final trimmed = entries.take(maxEntries).toList();
    final isOnBoard = trimmed.contains(newEntry);

    final p = await SharedPreferences.getInstance();
    await p.setString(_key, jsonEncode(trimmed.map((e) => e.toJson()).toList()));

    return isOnBoard ? rank : null;
  }

  static Future<void> clearAll() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_key);
  }
}
