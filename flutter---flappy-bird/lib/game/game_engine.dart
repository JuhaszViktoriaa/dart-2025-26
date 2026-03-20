import 'dart:math';
import 'package:flutter/material.dart';
import 'game_state.dart';
import '../utils/game_constants.dart';
import '../utils/score_manager.dart';
import '../utils/settings_manager.dart';
import '../utils/leaderboard_manager.dart';
import '../utils/sound_service.dart';

class GameEngine extends ChangeNotifier {
  late GameState state;
  double _screenWidth = 400;
  double _screenHeight = 700;
  final Random _random = Random();
  DateTime? _lastTick;

  Difficulty _difficulty = Difficulty.normal;
  String _playerName = 'Player';
  final SoundService _sound = SoundService();

  static const double _wingFrameInterval = 0.10;

  GameEngine() {
    state = GameState();
    _init();
  }

  Future<void> _init() async {
    state.highScore = await ScoreManager.getHighScore();
    _difficulty = await SettingsManager.getDifficulty();
    _playerName = await SettingsManager.getPlayerName();
    await _sound.init();
    notifyListeners();
  }

  Future<void> reloadSettings() async {
    _difficulty = await SettingsManager.getDifficulty();
    _playerName = await SettingsManager.getPlayerName();
    final soundOn = await SettingsManager.getSoundEnabled();
    final musicOn = await SettingsManager.getMusicEnabled();
    _sound.setSoundEnabled(soundOn);
    _sound.setMusicEnabled(musicOn);
    notifyListeners();
  }

  Difficulty get difficulty => _difficulty;

  void setScreenSize(double w, double h) {
    _screenWidth = w;
    _screenHeight = h;
  }

  double get birdStartY => _screenHeight * 0.4;
  double get playableHeight => _screenHeight - GameConstants.groundHeight;

  void startGame() {
    state = GameState(
      status: GameStatus.playing,
      birdY: birdStartY,
      birdVelocity: 0,
      highScore: state.highScore,
    );
    _lastTick = DateTime.now();
    _spawnInitialPipes();
    _sound.playSwoosh();
    notifyListeners();
  }

  void tap() {
    switch (state.status) {
      case GameStatus.idle:   startGame(); break;
      case GameStatus.playing: _jump(); break;
      case GameStatus.paused:  _resume(); break;
      case GameStatus.gameOver: startGame(); break;
    }
  }

  void togglePause() {
    if (state.status == GameStatus.playing) {
      state.status = GameStatus.paused;
      _lastTick = null;
      notifyListeners();
    } else if (state.status == GameStatus.paused) {
      _resume();
    }
  }

  void tick() {
    if (state.status != GameStatus.playing) return;
    final now = DateTime.now();
    final dt = _lastTick != null
        ? (now.difference(_lastTick!).inMicroseconds / 1_000_000.0).clamp(0.0, 0.05)
        : 0.016;
    _lastTick = now;
    _updateBird(dt);
    _updatePipes(dt);
    _updateScrolling(dt);
    _updateWingAnimation(dt);
    _checkCollisions();
    notifyListeners();
  }

  void _jump() {
    state.birdVelocity = GameConstants.jumpVelocity;
    state.birdFrame = 2;
    state.wingTimer = _wingFrameInterval;
    _sound.playFlap();
  }

  void _resume() {
    state.status = GameStatus.playing;
    _lastTick = DateTime.now();
    notifyListeners();
  }

  void _updateBird(double dt) {
    final gMult = SettingsManager.gravityMultiplier(_difficulty);
    state.birdVelocity += GameConstants.gravity * gMult * dt;
    state.birdY += state.birdVelocity * dt;
    final targetAngle = (state.birdVelocity / 600.0).clamp(-0.5, 1.2);
    state.birdAngle += (targetAngle - state.birdAngle) * 10 * dt;
  }

  void _updateWingAnimation(double dt) {
    state.wingTimer -= dt;
    if (state.wingTimer <= 0) {
      state.birdFrame = (state.birdFrame + 1) % 3;
      state.wingTimer = _wingFrameInterval;
    }
  }

  void _updatePipes(double dt) {
    final speed = _currentPipeSpeed();
    for (final pipe in state.pipes) {
      pipe.x -= speed * dt;
      if (!pipe.scored && pipe.x + GameConstants.pipeWidth < _birdX) {
        pipe.scored = true;
        state.score++;
        _sound.playScore();
        notifyListeners();
      }
    }
    state.pipes.removeWhere((p) => p.x + GameConstants.pipeWidth < 0);
    if (state.pipes.isEmpty ||
        state.pipes.last.x < _screenWidth - GameConstants.pipeSpacing) {
      _spawnPipe();
    }
  }

  void _updateScrolling(double dt) {
    final speed = _currentPipeSpeed();
    state.groundOffset = (state.groundOffset + speed * dt) % _screenWidth;
    state.bgOffset = (state.bgOffset + GameConstants.bgScrollSpeed * dt) % _screenWidth;
    state.cloudOffset = (state.cloudOffset + GameConstants.cloudScrollSpeed * dt) % _screenWidth;
  }

  void _checkCollisions() {
    if (state.birdY + GameConstants.birdHeight - GameConstants.hitBoxShrink >= playableHeight) {
      _triggerGameOver(); return;
    }
    if (state.birdY + GameConstants.hitBoxShrink <= 0) {
      state.birdVelocity = 0; state.birdY = 0;
    }
    final birdLeft   = _birdX + GameConstants.hitBoxShrink;
    final birdRight  = _birdX + GameConstants.birdWidth - GameConstants.hitBoxShrink;
    final birdTop    = state.birdY + GameConstants.hitBoxShrink;
    final birdBottom = state.birdY + GameConstants.birdHeight - GameConstants.hitBoxShrink;

    for (final pipe in state.pipes) {
      if (birdRight > pipe.x && birdLeft < pipe.x + GameConstants.pipeWidth) {
        final gap = _currentGap();
        if (birdTop < pipe.topHeight || birdBottom > pipe.topHeight + gap) {
          _triggerGameOver(); return;
        }
      }
    }
  }

  Future<void> _triggerGameOver() async {
    state.status = GameStatus.gameOver;
    _lastTick = null;
    _sound.playDie();
    state.isNewHighScore = await ScoreManager.saveHighScore(state.score);
    state.highScore = await ScoreManager.getHighScore();
    state.leaderboardRank =
        await LeaderboardManager.addEntry(_playerName, state.score);
    notifyListeners();
  }

  void _spawnInitialPipes() {
    state.pipes.clear();
    _spawnPipe(startX: _screenWidth + 80);
    _spawnPipe(startX: _screenWidth + 80 + GameConstants.pipeSpacing);
  }

  void _spawnPipe({double? startX}) {
    final gap = _currentGap();
    final minTop = 80.0;
    final maxTop = playableHeight - gap - 80.0;
    final topHeight = minTop + _random.nextDouble() * (maxTop - minTop);
    state.pipes.add(PipeData(
      x: startX ?? (_screenWidth + GameConstants.pipeWidth),
      topHeight: topHeight,
    ));
  }

  double get _birdX => _screenWidth * 0.22;

  double _currentPipeSpeed() {
    final sMult = SettingsManager.speedMultiplier(_difficulty);
    final extra = (state.score ~/ 5) * GameConstants.pipeSpeedIncrement;
    return ((GameConstants.pipeSpeed + extra) * sMult)
        .clamp(GameConstants.pipeSpeed * sMult, GameConstants.maxPipeSpeed * sMult);
  }

  double _currentGap() {
    final gMult = SettingsManager.gapMultiplier(_difficulty);
    final reduction = (state.score ~/ 10) * GameConstants.pipeGapDecrement;
    return ((GameConstants.pipeGap - reduction) * gMult)
        .clamp(GameConstants.pipeGapMin, GameConstants.pipeGap * gMult);
  }

  @override
  void dispose() { _sound.dispose(); super.dispose(); }
}
