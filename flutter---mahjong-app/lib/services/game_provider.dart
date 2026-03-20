import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/tile.dart';
import '../models/game_state.dart';
import '../models/board_layout.dart';
import 'game_service.dart';
import 'storage_service.dart';

class GameProvider extends ChangeNotifier {
  final GameService _gameService = GameService();
  final StorageService _storageService = StorageService();

  List<MahjongTile> _tiles = [];
  MahjongTile? _selectedTile;
  GameStatus _status = GameStatus.menu;
  BoardLayout _currentLayout = BoardLayouts.classic;
  int _score = 0;
  int _elapsedSeconds = 0;
  int _hintsRemaining = 3;
  int _shufflesRemaining = 2;
  int _comboMultiplier = 1;
  int _comboCount = 0;
  int _lastMatchTime = 0;
  List<MahjongTile>? _hintPair;
  Timer? _timer;
  GameStats _stats = GameStats();
  List<ScoreEntry> _highScores = [];
  Map<String, dynamic> _settings = {};
  bool _isAnimating = false;
  List<List<MahjongTile>> _undoHistory = [];

  // Getters
  List<MahjongTile> get tiles => _tiles;
  MahjongTile? get selectedTile => _selectedTile;
  GameStatus get status => _status;
  BoardLayout get currentLayout => _currentLayout;
  int get score => _score;
  int get elapsedSeconds => _elapsedSeconds;
  int get hintsRemaining => _hintsRemaining;
  int get shufflesRemaining => _shufflesRemaining;
  int get comboMultiplier => _comboMultiplier;
  List<MahjongTile>? get hintPair => _hintPair;
  GameStats get stats => _stats;
  List<ScoreEntry> get highScores => _highScores;
  Map<String, dynamic> get settings => _settings;
  bool get isAnimating => _isAnimating;

  int get remainingTiles => _tiles.where((t) => t.isVisible).length;
  int get totalTiles => _tiles.length;
  bool get isGameWon => remainingTiles == 0;
  bool get canUndo => _undoHistory.isNotEmpty;
  List<MahjongTile> get freeTiles => _gameService.getFreeTiles(_tiles);

  String get formattedTime {
    final m = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> initialize() async {
    _stats = await _storageService.loadStats();
    _highScores = await _storageService.loadHighScores();
    _settings = await _storageService.loadSettings();
    notifyListeners();
  }

  void setLayout(BoardLayout layout) {
    _currentLayout = layout;
    notifyListeners();
  }

  void startGame([BoardLayout? layout]) {
    if (layout != null) _currentLayout = layout;

    _timer?.cancel();
    _tiles = _gameService.generateTiles(_currentLayout);
    _selectedTile = null;
    _status = GameStatus.playing;
    _score = 0;
    _elapsedSeconds = 0;
    _hintsRemaining = 3;
    _shufflesRemaining = 2;
    _comboMultiplier = 1;
    _comboCount = 0;
    _hintPair = null;
    _undoHistory = [];
    _isAnimating = false;

    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_status == GameStatus.playing) {
        _elapsedSeconds++;
        notifyListeners();
      }
    });
  }

  void pauseGame() {
    if (_status == GameStatus.playing) {
      _status = GameStatus.paused;
      _timer?.cancel();
      notifyListeners();
    }
  }

  void resumeGame() {
    if (_status == GameStatus.paused) {
      _status = GameStatus.playing;
      _startTimer();
      notifyListeners();
    }
  }

  void returnToMenu() {
    _timer?.cancel();
    _status = GameStatus.menu;
    _tiles = [];
    _selectedTile = null;
    _hintPair = null;
    notifyListeners();
  }

  void selectTile(MahjongTile tile) {
    if (_isAnimating || _status != GameStatus.playing) return;
    if (!_gameService.isTileFree(tile, _tiles)) return;

    // Clear hint highlight
    _hintPair = null;

    if (_selectedTile == null) {
      // First selection
      _selectedTile = tile;
      _updateTileState(tile.id, TileState.selected);
    } else if (_selectedTile!.id == tile.id) {
      // Deselect
      _selectedTile = null;
      _updateTileState(tile.id, TileState.normal);
    } else {
      // Second selection - check match
      if (_selectedTile!.matches(tile)) {
        _handleMatch(_selectedTile!, tile);
      } else {
        // No match - move selection to new tile
        _updateTileState(_selectedTile!.id, TileState.normal);
        _selectedTile = tile;
        _updateTileState(tile.id, TileState.selected);
        _comboMultiplier = 1;
        _comboCount = 0;
      }
    }
    notifyListeners();
  }

  Future<void> _handleMatch(MahjongTile a, MahjongTile b) async {
    _isAnimating = true;

    // Save undo state
    _undoHistory.add(List<MahjongTile>.from(_tiles.map((t) => MahjongTile(
      id: t.id, suit: t.suit, value: t.value,
      row: t.row, col: t.col, layer: t.layer,
      state: TileState.normal, isVisible: t.isVisible,
    ))));
    if (_undoHistory.length > 5) _undoHistory.removeAt(0);

    // Update combo
    final now = _elapsedSeconds;
    if (now - _lastMatchTime <= 3) {
      _comboCount++;
      _comboMultiplier = (_comboCount ~/ 2) + 1;
      if (_comboMultiplier > 5) _comboMultiplier = 5;
    } else {
      _comboCount = 1;
      _comboMultiplier = 1;
    }
    _lastMatchTime = now;

    // Score
    final matchScore = _gameService.calculateMatchScore(a, b, _comboMultiplier);
    _score += matchScore;

    // Animate match
    _updateTileState(a.id, TileState.matched);
    _updateTileState(b.id, TileState.matched);
    _selectedTile = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    // Remove matched tiles
    _setTileVisible(a.id, false);
    _setTileVisible(b.id, false);
    _isAnimating = false;

    // Check win/no-moves
    if (isGameWon) {
      _onGameWon();
    } else if (!_gameService.hasValidMoves(_tiles)) {
      _status = GameStatus.noMoves;
    }

    notifyListeners();
  }

  void _onGameWon() {
    _timer?.cancel();
    _status = GameStatus.won;
    final bonus = _gameService.calculateTimeBonus(_elapsedSeconds);
    _score += bonus;

    // Update stats
    _stats.gamesPlayed++;
    _stats.gamesWon++;
    _stats.totalScore += _score;
    if (_stats.bestTime == 0 || _elapsedSeconds < _stats.bestTime) {
      _stats.bestTime = _elapsedSeconds;
    }
    _storageService.saveStats(_stats);

    // Save high score
    final entry = ScoreEntry(
      score: _score,
      time: _elapsedSeconds,
      date: DateTime.now(),
      layout: _currentLayout.name,
    );
    _storageService.saveHighScore(entry);
    _highScores = [entry, ..._highScores]
      ..sort((a, b) => b.score.compareTo(a.score));
    if (_highScores.length > 10) _highScores = _highScores.sublist(0, 10);
  }

  void useHint() {
    if (_hintsRemaining <= 0 || _status != GameStatus.playing) return;
    _hintsRemaining--;
    _hintPair = _gameService.findHint(_tiles);
    notifyListeners();
  }

  void useShuffle() {
    if (_shufflesRemaining <= 0 || _status != GameStatus.playing) return;
    _shufflesRemaining--;
    _tiles = _gameService.shuffleTiles(_tiles);
    _selectedTile = null;
    _hintPair = null;
    notifyListeners();
  }

  void undoLastMove() {
    if (_undoHistory.isEmpty || _status != GameStatus.playing) return;
    _tiles = _undoHistory.removeLast();
    _selectedTile = null;
    _hintPair = null;
    _score = (_score - 10).clamp(0, double.maxFinite.toInt());
    notifyListeners();
  }

  void _updateTileState(String id, TileState state) {
    final idx = _tiles.indexWhere((t) => t.id == id);
    if (idx != -1) {
      final t = _tiles[idx];
      _tiles[idx] = MahjongTile(
        id: t.id, suit: t.suit, value: t.value,
        row: t.row, col: t.col, layer: t.layer,
        state: state, isVisible: t.isVisible,
      );
    }
  }

  void _setTileVisible(String id, bool visible) {
    final idx = _tiles.indexWhere((t) => t.id == id);
    if (idx != -1) {
      final t = _tiles[idx];
      _tiles[idx] = MahjongTile(
        id: t.id, suit: t.suit, value: t.value,
        row: t.row, col: t.col, layer: t.layer,
        state: TileState.normal, isVisible: visible,
      );
    }
  }

  Future<void> updateSetting(String key, dynamic value) async {
    _settings[key] = value;
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> resetStats() async {
    await _storageService.resetAll();
    _stats = GameStats();
    _highScores = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
