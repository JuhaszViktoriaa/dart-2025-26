import 'dart:math';
import 'package:flutter/material.dart';
import '../game/game_state.dart';
import '../utils/app_theme.dart';
import '../utils/game_constants.dart';

class GamePainter extends CustomPainter {
  final GameState state;
  final double screenWidth;
  final double screenHeight;

  // Wing y-offsets per animation frame (0=mid, 1=down, 2=up)
  static const List<double> _wingOffsets = [0.45, 0.62, 0.22];
  static const List<double> _wingHeights = [0.35, 0.22, 0.22];

  GamePainter({
    required this.state,
    required this.screenWidth,
    required this.screenHeight,
  });

  double get playableHeight => screenHeight - GameConstants.groundHeight;
  double get birdX => screenWidth * 0.22;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawClouds(canvas, size);
    _drawPipes(canvas);
    _drawGround(canvas, size);
    _drawBird(canvas);
  }

  void _drawBackground(Canvas canvas, Size size) {
    // Gradient sky: deep plum → mid plum → rosy horizon
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.deepPlumBg,
          AppTheme.midPlum,
          AppTheme.plum,
          Color(0xFFAD4070),
        ],
        stops: [0.0, 0.4, 0.75, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, playableHeight));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, playableHeight), paint);

    // Subtle star-like sparkles (decorative dots)
    _drawStars(canvas, size);
  }

  void _drawStars(Canvas canvas, Size size) {
    final paint = Paint()..color = AppTheme.blushPink.withOpacity(0.25);
    final rng = Random(42); // fixed seed → stable stars
    for (int i = 0; i < 28; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * playableHeight * 0.7;
      final r = rng.nextDouble() * 1.8 + 0.5;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  void _drawClouds(Canvas canvas, Size size) {
    final paint = Paint()..color = AppTheme.plumPale.withOpacity(0.18);
    final cloudPositions = [
      Offset(80, 70),
      Offset(230, 40),
      Offset(370, 90),
      Offset(520, 55),
    ];

    canvas.save();
    for (final base in cloudPositions) {
      final x = (base.dx - state.cloudOffset) % (size.width + 120) - 60;
      _drawCloud(canvas, Offset(x, base.dy), paint);
    }
    canvas.restore();
  }

  void _drawCloud(Canvas canvas, Offset center, Paint paint) {
    canvas.drawOval(Rect.fromCenter(center: center, width: 90, height: 36), paint);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(center.dx - 28, center.dy - 14), width: 54, height: 32),
        paint);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(center.dx + 28, center.dy - 10), width: 46, height: 28),
        paint);
  }

  void _drawPipes(Canvas canvas) {
    for (final pipe in state.pipes) {
      _drawPipePair(canvas, pipe);
    }
  }

  void _drawPipePair(Canvas canvas, PipeData pipe) {
    final gap = GameConstants.pipeGap;
    final gapTop = pipe.topHeight;
    final gapBottom = gapTop + gap;
    final pipeW = GameConstants.pipeWidth;

    // Top pipe body
    _drawPipeSegment(
      canvas,
      Rect.fromLTWH(pipe.x, 0, pipeW, gapTop - 14),
      isTop: true,
    );
    // Top pipe cap
    _drawPipeCap(
      canvas,
      Rect.fromLTWH(pipe.x - 5, gapTop - 28, pipeW + 10, 28),
    );

    // Bottom pipe body
    _drawPipeSegment(
      canvas,
      Rect.fromLTWH(pipe.x, gapBottom + 14, pipeW, playableHeight - gapBottom - 14),
      isTop: false,
    );
    // Bottom pipe cap
    _drawPipeCap(
      canvas,
      Rect.fromLTWH(pipe.x - 5, gapBottom, pipeW + 10, 28),
    );
  }

  void _drawPipeSegment(Canvas canvas, Rect rect, {required bool isTop}) {
    if (rect.height <= 0) return;

    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          AppTheme.plum.withOpacity(0.95),
          AppTheme.plumLight,
          AppTheme.rosePink.withOpacity(0.6),
          AppTheme.plumLight,
          AppTheme.plum.withOpacity(0.95),
        ],
        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
      ).createShader(rect);

    final rr = RRect.fromRectAndRadius(rect, const Radius.circular(4));
    canvas.drawRRect(rr, bodyPaint);

    // Highlight stripe
    final highlightPaint = Paint()
      ..color = AppTheme.blushPink.withOpacity(0.15)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(rect.left + 8, rect.top, 12, rect.height),
        const Radius.circular(4),
      ),
      highlightPaint,
    );
  }

  void _drawPipeCap(Canvas canvas, Rect rect) {
    final capPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          AppTheme.midPlum,
          AppTheme.plumLight,
          AppTheme.hotPink.withOpacity(0.5),
          AppTheme.plumLight,
          AppTheme.midPlum,
        ],
        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
      ).createShader(rect);

    final rr = RRect.fromRectAndRadius(rect, const Radius.circular(6));
    canvas.drawRRect(rr, capPaint);

    // Edge glow
    final glowPaint = Paint()
      ..color = AppTheme.rosePink.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(rr, glowPaint);
  }

  void _drawGround(Canvas canvas, Size size) {
    final groundY = playableHeight;

    // Ground gradient
    final groundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppTheme.plum, AppTheme.deepPlumBg],
      ).createShader(
          Rect.fromLTWH(0, groundY, size.width, GameConstants.groundHeight));

    canvas.drawRect(
        Rect.fromLTWH(0, groundY, size.width, GameConstants.groundHeight),
        groundPaint);

    // Ground top border glow
    final borderPaint = Paint()
      ..color = AppTheme.hotPink.withOpacity(0.6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, groundY), Offset(size.width, groundY), borderPaint);

    // Scrolling ground tiles
    _drawGroundTiles(canvas, size, groundY);
  }

  void _drawGroundTiles(Canvas canvas, Size size, double groundY) {
    final tilePaint = Paint()
      ..color = AppTheme.plumPale.withOpacity(0.15)
      ..strokeWidth = 1;
    final tileWidth = 40.0;
    final offset = state.groundOffset % tileWidth;

    for (double x = -offset; x < size.width; x += tileWidth) {
      canvas.drawLine(
        Offset(x, groundY + 12),
        Offset(x + tileWidth * 0.7, groundY + 12),
        tilePaint,
      );
    }
  }

  void _drawBird(Canvas canvas) {
    canvas.save();
    final cx = birdX + GameConstants.birdWidth / 2;
    final cy = state.birdY + GameConstants.birdHeight / 2;

    canvas.translate(cx, cy);
    canvas.rotate(state.birdAngle);
    canvas.translate(-GameConstants.birdWidth / 2, -GameConstants.birdHeight / 2);

    _paintBirdBody(canvas);

    canvas.restore();
  }

  void _paintBirdBody(Canvas canvas) {
    final w = GameConstants.birdWidth;
    final h = GameConstants.birdHeight;

    // Drop shadow
    final shadowPaint = Paint()
      ..color = Colors.black26
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawOval(
        Rect.fromLTWH(4, 6, w - 4, h - 4), shadowPaint);

    // Body gradient: hot pink → blush
    final bodyPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 0.8,
        colors: [AppTheme.blushPink, AppTheme.rosePink, AppTheme.hotPink],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawOval(Rect.fromLTWH(0, 0, w, h), bodyPaint);

    // Wing — animated per frame
    final frame = state.birdFrame.clamp(0, 2);
    final wingY = h * _wingOffsets[frame];
    final wingH = h * _wingHeights[frame];
    final wingPaint = Paint()..color = AppTheme.plumLight.withOpacity(0.85);
    canvas.drawOval(Rect.fromLTWH(8, wingY, w * 0.38, wingH), wingPaint);

    // Eye white
    final eyeWhitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.68, h * 0.28), 8, eyeWhitePaint);

    // Pupil
    final pupilPaint = Paint()..color = AppTheme.deepPlumBg;
    canvas.drawCircle(Offset(w * 0.72, h * 0.28), 4.5, pupilPaint);

    // Eye shine
    final shinePaint = Paint()..color = Colors.white70;
    canvas.drawCircle(Offset(w * 0.74, h * 0.24), 1.8, shinePaint);

    // Beak
    final beakPaint = Paint()..color = AppTheme.goldAccent;
    final beakPath = Path()
      ..moveTo(w * 0.88, h * 0.40)
      ..lineTo(w + 8, h * 0.50)
      ..lineTo(w * 0.88, h * 0.60)
      ..close();
    canvas.drawPath(beakPath, beakPaint);

    // Body outline / glow
    final outlinePaint = Paint()
      ..color = AppTheme.hotPink.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawOval(Rect.fromLTWH(0, 0, w, h), outlinePaint);
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) => true;
}
