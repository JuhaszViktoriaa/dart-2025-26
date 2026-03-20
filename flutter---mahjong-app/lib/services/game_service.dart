import 'dart:math';
import '../models/tile.dart';
import '../models/board_layout.dart';

class GameService {
  static const int _tilesPerType = 4; // 4 of each numbered tile (except special)
  final Random _random = Random();

  /// Generate a shuffled, solvable set of tiles for the given layout
  List<MahjongTile> generateTiles(BoardLayout layout) {
    final positions = layout.positions;
    final int totalTiles = positions.length;

    // Ensure total tiles is even
    final int usableTiles = (totalTiles ~/ 2) * 2;

    // Build tile pool
    final tilePool = _buildTilePool(usableTiles);

    // Shuffle tile pool
    tilePool.shuffle(_random);

    // Assign tiles to positions
    final tiles = <MahjongTile>[];
    for (int i = 0; i < usableTiles; i++) {
      final pos = positions[i];
      final tileData = tilePool[i];
      tiles.add(MahjongTile(
        id: 'tile_$i',
        suit: tileData['suit'] as TileSuit,
        value: tileData['value'] as int,
        row: pos.row,
        col: pos.col,
        layer: pos.layer,
      ));
    }

    return tiles;
  }

  List<Map<String, dynamic>> _buildTilePool(int needed) {
    final pool = <Map<String, dynamic>>[];

    // Numbered suits: 9 values × 4 copies = 36 per suit, 3 suits = 108
    for (final suit in [TileSuit.bamboo, TileSuit.characters, TileSuit.circles]) {
      for (int v = 1; v <= 9; v++) {
        for (int c = 0; c < 4; c++) {
          pool.add({'suit': suit, 'value': v});
        }
      }
    }

    // Winds: 4 values × 4 copies = 16
    for (int v = 1; v <= 4; v++) {
      for (int c = 0; c < 4; c++) {
        pool.add({'suit': TileSuit.winds, 'value': v});
      }
    }

    // Dragons: 3 values × 4 copies = 12
    for (int v = 1; v <= 3; v++) {
      for (int c = 0; c < 4; c++) {
        pool.add({'suit': TileSuit.dragons, 'value': v});
      }
    }

    // Flowers: 4 unique tiles (all match each other)
    for (int v = 1; v <= 4; v++) {
      pool.add({'suit': TileSuit.flowers, 'value': v});
    }

    // Seasons: 4 unique tiles (all match each other)
    for (int v = 1; v <= 4; v++) {
      pool.add({'suit': TileSuit.seasons, 'value': v});
    }

    // Total: 108 + 16 + 12 + 4 + 4 = 144

    // Pair up pool: ensure every tile has exactly one match
    // Take pairs from pool
    final pairedPool = <Map<String, dynamic>>[];
    final tempPool = List<Map<String, dynamic>>.from(pool);
    tempPool.shuffle(_random);

    // Group by matching key
    final Map<String, List<Map<String, dynamic>>> groups = {};
    for (final tile in tempPool) {
      final key = _matchKey(tile);
      groups.putIfAbsent(key, () => []).add(tile);
    }

    // Take pairs
    for (final group in groups.values) {
      final shuffled = List<Map<String, dynamic>>.from(group)..shuffle(_random);
      // Add pairs
      for (int i = 0; i + 1 < shuffled.length; i += 2) {
        pairedPool.add(shuffled[i]);
        pairedPool.add(shuffled[i + 1]);
      }
    }

    // Trim or extend to needed
    if (pairedPool.length >= needed) {
      pairedPool.shuffle(_random);
      return pairedPool.sublist(0, needed);
    }

    // If not enough, fill with more pairs
    while (pairedPool.length < needed) {
      final suit = [TileSuit.bamboo, TileSuit.characters, TileSuit.circles][_random.nextInt(3)];
      final value = _random.nextInt(9) + 1;
      pairedPool.add({'suit': suit, 'value': value});
      pairedPool.add({'suit': suit, 'value': value});
    }

    pairedPool.shuffle(_random);
    return pairedPool.sublist(0, needed);
  }

  String _matchKey(Map<String, dynamic> tile) {
    final suit = tile['suit'] as TileSuit;
    if (suit == TileSuit.flowers) return 'flowers';
    if (suit == TileSuit.seasons) return 'seasons';
    return '${suit.name}_${tile['value']}';
  }

  /// Determine which tiles are currently "free" (can be selected)
  /// A tile is free if:
  /// 1. Nothing is on top of it
  /// 2. It has at least one free side (left or right)
  List<MahjongTile> getFreeTiles(List<MahjongTile> tiles) {
    return tiles.where((t) => t.isVisible && isTileFree(t, tiles)).toList();
  }

  bool isTileFree(MahjongTile tile, List<MahjongTile> allTiles) {
    final visibleTiles = allTiles.where((t) => t.isVisible && t.id != tile.id).toList();

    // Check if anything is on top
    for (final other in visibleTiles) {
      if (other.layer == tile.layer + 1) {
        // Other tile overlaps this one if they share area
        if (_overlaps(tile, other)) return false;
      }
    }

    // Check left side blocked
    final leftBlocked = visibleTiles.any((other) =>
      other.layer == tile.layer &&
      other.col == tile.col - 2 &&
      (other.row - tile.row).abs() < 2
    );

    // Check right side blocked
    final rightBlocked = visibleTiles.any((other) =>
      other.layer == tile.layer &&
      other.col == tile.col + 2 &&
      (other.row - tile.row).abs() < 2
    );

    return !leftBlocked || !rightBlocked;
  }

  bool _overlaps(MahjongTile a, MahjongTile b) {
    // Tiles overlap if their centers are within 1 unit in each direction
    return (a.col - b.col).abs() < 2 && (a.row - b.row).abs() < 2;
  }

  /// Find a valid matching pair among free tiles
  List<MahjongTile>? findHint(List<MahjongTile> tiles) {
    final free = getFreeTiles(tiles);
    for (int i = 0; i < free.length; i++) {
      for (int j = i + 1; j < free.length; j++) {
        if (free[i].matches(free[j])) {
          return [free[i], free[j]];
        }
      }
    }
    return null;
  }

  /// Check if there are any valid moves left
  bool hasValidMoves(List<MahjongTile> tiles) {
    return findHint(tiles) != null;
  }

  /// Calculate score for a match
  int calculateMatchScore(MahjongTile a, MahjongTile b, int comboMultiplier) {
    int base = 10;
    // Bonus for special tiles
    if (a.suit == TileSuit.flowers || a.suit == TileSuit.seasons) base = 25;
    if (a.suit == TileSuit.dragons) base = 20;
    if (a.suit == TileSuit.winds) base = 15;
    return base * comboMultiplier;
  }

  /// Calculate time bonus
  int calculateTimeBonus(int elapsedSeconds) {
    if (elapsedSeconds < 60) return 500;
    if (elapsedSeconds < 120) return 300;
    if (elapsedSeconds < 180) return 150;
    if (elapsedSeconds < 300) return 50;
    return 0;
  }

  /// Shuffle remaining tiles while keeping them solvable
  List<MahjongTile> shuffleTiles(List<MahjongTile> tiles) {
    final visibleTiles = tiles.where((t) => t.isVisible).toList();
    if (visibleTiles.length < 2) return tiles;

    // Extract tile types from visible tiles
    final tileTypes = visibleTiles.map((t) => {'suit': t.suit, 'value': t.value}).toList();
    tileTypes.shuffle(_random);

    // Reassign types to same positions
    final newTiles = List<MahjongTile>.from(tiles);
    for (int i = 0; i < visibleTiles.length; i++) {
      final original = visibleTiles[i];
      final idx = newTiles.indexWhere((t) => t.id == original.id);
      if (idx != -1) {
        newTiles[idx] = MahjongTile(
          id: original.id,
          suit: tileTypes[i]['suit'] as TileSuit,
          value: tileTypes[i]['value'] as int,
          row: original.row,
          col: original.col,
          layer: original.layer,
          state: TileState.normal,
          isVisible: true,
        );
      }
    }
    return newTiles;
  }
}