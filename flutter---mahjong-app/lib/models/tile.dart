import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum TileSuit { bamboo, characters, circles, winds, dragons, flowers, seasons }

enum TileState { normal, selected, matched, hint, blocked }

class MahjongTile {
  final String id;
  final TileSuit suit;
  final int value; // 1-9 for numbered, 1-4 for winds/flowers/seasons, 1-3 for dragons
  int row;
  int col;
  int layer;
  TileState state;
  bool isVisible;

  MahjongTile({
    required this.id,
    required this.suit,
    required this.value,
    required this.row,
    required this.col,
    required this.layer,
    this.state = TileState.normal,
    this.isVisible = true,
  });

  // Two tiles match if they have the same suit and value
  // Flowers (1-4) all match each other, Seasons (1-4) all match each other
  bool matches(MahjongTile other) {
    if (suit == TileSuit.flowers && other.suit == TileSuit.flowers) return true;
    if (suit == TileSuit.seasons && other.suit == TileSuit.seasons) return true;
    return suit == other.suit && value == other.value;
  }

  String get displaySymbol {
    switch (suit) {
      case TileSuit.bamboo:
        return _bambooSymbols[value - 1];
      case TileSuit.characters:
        return _characterSymbols[value - 1];
      case TileSuit.circles:
        return _circleSymbols[value - 1];
      case TileSuit.winds:
        return _windSymbols[value - 1];
      case TileSuit.dragons:
        return _dragonSymbols[value - 1];
      case TileSuit.flowers:
        return _flowerSymbols[value - 1];
      case TileSuit.seasons:
        return _seasonSymbols[value - 1];
    }
  }

  String get suitLabel {
    switch (suit) {
      case TileSuit.bamboo: return 'Bamboo';
      case TileSuit.characters: return 'Char';
      case TileSuit.circles: return 'Circle';
      case TileSuit.winds: return 'Wind';
      case TileSuit.dragons: return 'Dragon';
      case TileSuit.flowers: return 'Flower';
      case TileSuit.seasons: return 'Season';
    }
  }

  Color get symbolColor {
    switch (suit) {
      case TileSuit.bamboo: return AppTheme.tileGreen;
      case TileSuit.characters: return AppTheme.tileRed;
      case TileSuit.circles: return AppTheme.tileBlue;
      case TileSuit.winds: return AppTheme.tileBlack;
      case TileSuit.dragons: return AppTheme.tileRed;
      case TileSuit.flowers: return const Color(0xFFE91E8C);
      case TileSuit.seasons: return const Color(0xFF7B1FA2);
    }
  }

  Color get accentColor {
    switch (suit) {
      case TileSuit.bamboo: return const Color(0xFF81C784);
      case TileSuit.characters: return const Color(0xFFEF9A9A);
      case TileSuit.circles: return const Color(0xFF64B5F6);
      case TileSuit.winds: return const Color(0xFF90A4AE);
      case TileSuit.dragons: return const Color(0xFFFFCC02);
      case TileSuit.flowers: return const Color(0xFFF48FB1);
      case TileSuit.seasons: return const Color(0xFFCE93D8);
    }
  }

  MahjongTile copyWith({TileState? state}) {
    return MahjongTile(
      id: id,
      suit: suit,
      value: value,
      row: row,
      col: col,
      layer: layer,
      state: state ?? this.state,
      isVisible: isVisible,
    );
  }

  static const _bambooSymbols = ['🎋', '🎍', '🪵', '🌿', '🎏', '🌱', '🌾', '🍃', '🪴'];
  static const _characterSymbols = ['一', '二', '三', '四', '五', '六', '七', '八', '九'];
  static const _circleSymbols = ['①', '②', '③', '④', '⑤', '⑥', '⑦', '⑧', '⑨'];
  static const _windSymbols = ['東', '南', '西', '北'];
  static const _dragonSymbols = ['中', '發', '白'];
  static const _flowerSymbols = ['🌸', '🌺', '🌼', '🌻'];
  static const _seasonSymbols = ['🌱', '☀️', '🍂', '❄️'];
}