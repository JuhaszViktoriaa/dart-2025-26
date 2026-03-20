class GameConstants {
  // Physics — tuned for beginner-friendly gameplay
  static const double gravity = 1800.0;         // px/s² (lower = floatier)
  static const double jumpVelocity = -520.0;    // px/s  (more negative = higher jump)
  static const double pipeSpeed = 160.0;        // px/s
  static const double pipeSpeedIncrement = 5.0; // added every 5 points
  static const double maxPipeSpeed = 280.0;

  // Bird dimensions
  static const double birdWidth = 52.0;
  static const double birdHeight = 40.0;
  static const double birdStartX = 80.0;        // fixed x position (fraction of width)

  // Pipes
  static const double pipeWidth = 70.0;
  static const double pipeGap = 220.0;          // vertical gap — large for beginners
  static const double pipeGapMin = 170.0;
  static const double pipeGapDecrement = 5.0;   // gap narrows every 10 points
  static const double pipeSpacing = 260.0;      // horizontal gap between pipes

  // Ground
  static const double groundHeight = 80.0;

  // Scroll speed of background parallax layers
  static const double bgScrollSpeed = 30.0;
  static const double cloudScrollSpeed = 50.0;
  static const double groundScrollSpeed = 1.0; // multiplier of pipeSpeed

  // Hit-box shrink (makes collisions feel fair)
  static const double hitBoxShrink = 8.0;
}
