enum GameStatus { idle, playing, paused, gameOver }

class PipeData {
  double x;
  double topHeight; // height of top pipe from top of screen
  bool scored;

  PipeData({
    required this.x,
    required this.topHeight,
    this.scored = false,
  });
}

class GameState {
  GameStatus status;
  double birdY;         // top of bird from top of screen
  double birdVelocity;  // px/s, positive = falling
  double birdAngle;     // radians for rotation
  int birdFrame;        // 0-2 animation frame for wing flap
  double wingTimer;     // seconds until next frame
  List<PipeData> pipes;
  int score;
  int highScore;
  bool isNewHighScore;
  int? leaderboardRank; // rank earned this run, null if not on board
  double groundOffset;  // for scrolling ground
  double bgOffset;      // parallax background
  double cloudOffset;   // cloud layer offset

  GameState({
    this.status = GameStatus.idle,
    this.birdY = 0,
    this.birdVelocity = 0,
    this.birdAngle = 0,
    this.birdFrame = 0,
    this.wingTimer = 0,
    List<PipeData>? pipes,
    this.score = 0,
    this.highScore = 0,
    this.isNewHighScore = false,
    this.leaderboardRank,
    this.groundOffset = 0,
    this.bgOffset = 0,
    this.cloudOffset = 0,
  }) : pipes = pipes ?? [];
}
