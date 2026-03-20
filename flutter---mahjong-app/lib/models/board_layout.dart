class TilePosition {
  final int row;
  final int col;
  final int layer;

  const TilePosition(this.row, this.col, this.layer);
}

class BoardLayout {
  final String name;
  final String description;
  final String emoji;
  final List<TilePosition> positions;
  final int difficulty; // 1-3

  const BoardLayout({
    required this.name,
    required this.description,
    required this.emoji,
    required this.positions,
    required this.difficulty,
  });

  int get tileCount => positions.length;
}

class BoardLayouts {
  static BoardLayout get classic => BoardLayout(
    name: 'Classic',
    description: 'The traditional turtle layout',
    emoji: '🐢',
    difficulty: 2,
    positions: _classicPositions,
  );

  static BoardLayout get cross => BoardLayout(
    name: 'Cross',
    description: 'A cross-shaped challenge',
    emoji: '✚',
    difficulty: 1,
    positions: _crossPositions,
  );

  static BoardLayout get pyramid => BoardLayout(
    name: 'Pyramid',
    description: 'Build your way to the top',
    emoji: '🔺',
    difficulty: 3,
    positions: _pyramidPositions,
  );

  static List<BoardLayout> get all => [classic, cross, pyramid];

  // Classic turtle layout - 144 tiles across 5 layers
  // Represented as (row, col, layer) — col/row are in half-tile units
  static List<TilePosition> get _classicPositions {
    final positions = <TilePosition>[];

    // Layer 0 - base (12x8 grid area, with gaps)
    final layer0 = [
      // Row 0
      [0,4],[0,6],[0,8],[0,10],[0,12],[0,14],[0,16],[0,18],[0,20],[0,22],[0,24],[0,26],
      // Row 1
      [2,2],[2,4],[2,6],[2,8],[2,10],[2,12],[2,14],[2,16],[2,18],[2,20],[2,22],[2,24],[2,26],[2,28],
      // Row 2
      [4,2],[4,4],[4,6],[4,8],[4,10],[4,12],[4,14],[4,16],[4,18],[4,20],[4,22],[4,24],[4,26],[4,28],
      // Row 3 (with side wings)
      [6,0],[6,2],[6,4],[6,6],[6,8],[6,10],[6,12],[6,14],[6,16],[6,18],[6,20],[6,22],[6,24],[6,26],[6,28],[6,30],
      // Row 4
      [8,2],[8,4],[8,6],[8,8],[8,10],[8,12],[8,14],[8,16],[8,18],[8,20],[8,22],[8,24],[8,26],[8,28],
      // Row 5
      [10,2],[10,4],[10,6],[10,8],[10,10],[10,12],[10,14],[10,16],[10,18],[10,20],[10,22],[10,24],[10,26],[10,28],
      // Row 6
      [12,4],[12,6],[12,8],[12,10],[12,12],[12,14],[12,16],[12,18],[12,20],[12,22],[12,24],[12,26],
    ];

    for (final pos in layer0) {
      positions.add(TilePosition(pos[0], pos[1], 0));
    }

    // Layer 1
    final layer1 = [
      [2,6],[2,8],[2,10],[2,12],[2,14],[2,16],[2,18],[2,20],[2,22],[2,24],
      [4,6],[4,8],[4,10],[4,12],[4,14],[4,16],[4,18],[4,20],[4,22],[4,24],
      [6,6],[6,8],[6,10],[6,12],[6,14],[6,16],[6,18],[6,20],[6,22],[6,24],
      [8,6],[8,8],[8,10],[8,12],[8,14],[8,16],[8,18],[8,20],[8,22],[8,24],
      [10,6],[10,8],[10,10],[10,12],[10,14],[10,16],[10,18],[10,20],[10,22],[10,24],
    ];

    for (final pos in layer1) {
      positions.add(TilePosition(pos[0], pos[1], 1));
    }

    // Layer 2
    final layer2 = [
      [4,10],[4,12],[4,14],[4,16],[4,18],[4,20],
      [6,10],[6,12],[6,14],[6,16],[6,18],[6,20],
      [8,10],[8,12],[8,14],[8,16],[8,18],[8,20],
    ];

    for (final pos in layer2) {
      positions.add(TilePosition(pos[0], pos[1], 2));
    }

    // Layer 3
    final layer3 = [
      [6,12],[6,14],[6,16],[6,18],
      [8,12],[8,14],[8,16],[8,18],
    ];

    for (final pos in layer3) {
      positions.add(TilePosition(pos[0], pos[1], 3));
    }

    // Layer 4 (top)
    positions.add(const TilePosition(7, 14, 4));
    positions.add(const TilePosition(7, 16, 4));

    return positions;
  }

  static List<TilePosition> get _crossPositions {
    final positions = <TilePosition>[];
    // Vertical bar
    for (int r = 0; r <= 12; r += 2) {
      for (int c = 12; c <= 16; c += 2) {
        positions.add(TilePosition(r, c, 0));
      }
    }
    // Horizontal bar
    for (int r = 4; r <= 8; r += 2) {
      for (int c = 4; c <= 24; c += 2) {
        if (c < 12 || c > 16) positions.add(TilePosition(r, c, 0));
      }
    }
    // Layer 1 - center area
    for (int r = 4; r <= 8; r += 2) {
      for (int c = 12; c <= 16; c += 2) {
        positions.add(TilePosition(r, c, 1));
      }
    }
    // Layer 2
    positions.add(const TilePosition(6, 14, 2));
    return positions;
  }

  static List<TilePosition> get _pyramidPositions {
    final positions = <TilePosition>[];
    // Base layer - wide
    for (int c = 2; c <= 28; c += 2) {
      positions.add(TilePosition(10, c, 0));
    }
    for (int c = 2; c <= 28; c += 2) {
      positions.add(TilePosition(8, c, 0));
    }
    // Second row pair
    for (int c = 4; c <= 26; c += 2) {
      positions.add(TilePosition(6, c, 0));
    }
    for (int c = 4; c <= 26; c += 2) {
      positions.add(TilePosition(4, c, 0));
    }

    // Layer 1
    for (int c = 6; c <= 24; c += 2) {
      positions.add(TilePosition(8, c, 1));
    }
    for (int c = 6; c <= 24; c += 2) {
      positions.add(TilePosition(6, c, 1));
    }

    // Layer 2
    for (int c = 10; c <= 20; c += 2) {
      positions.add(TilePosition(7, c, 2));
    }

    // Layer 3
    for (int c = 12; c <= 18; c += 2) {
      positions.add(TilePosition(7, c, 3));
    }

    // Top
    positions.add(const TilePosition(7, 14, 4));
    positions.add(const TilePosition(7, 16, 4));

    return positions;
  }
}