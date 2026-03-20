enum GameStatus { menu, playing, paused, won, lost, noMoves }

class GameStats {
  int gamesPlayed;
  int gamesWon;
  int bestTime; // in seconds, 0 = never won
  int totalScore;

  GameStats({
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.bestTime = 0,
    this.totalScore = 0,
  });

  double get winRate => gamesPlayed == 0 ? 0 : (gamesWon / gamesPlayed * 100);

  Map<String, dynamic> toJson() => {
    'gamesPlayed': gamesPlayed,
    'gamesWon': gamesWon,
    'bestTime': bestTime,
    'totalScore': totalScore,
  };

  factory GameStats.fromJson(Map<String, dynamic> json) => GameStats(
    gamesPlayed: json['gamesPlayed'] ?? 0,
    gamesWon: json['gamesWon'] ?? 0,
    bestTime: json['bestTime'] ?? 0,
    totalScore: json['totalScore'] ?? 0,
  );
}

class ScoreEntry {
  final int score;
  final int time;
  final DateTime date;
  final String layout;

  ScoreEntry({
    required this.score,
    required this.time,
    required this.date,
    required this.layout,
  });

  Map<String, dynamic> toJson() => {
    'score': score,
    'time': time,
    'date': date.toIso8601String(),
    'layout': layout,
  };

  factory ScoreEntry.fromJson(Map<String, dynamic> json) => ScoreEntry(
    score: json['score'] ?? 0,
    time: json['time'] ?? 0,
    date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    layout: json['layout'] ?? 'Classic',
  );
}