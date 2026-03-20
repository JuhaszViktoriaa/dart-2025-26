import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tile.dart';
import '../services/game_provider.dart';
import 'tile_widget.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        if (game.tiles.isEmpty) return const SizedBox();

        // Calculate board bounds
        final visibleTiles = game.tiles;
        if (visibleTiles.isEmpty) return const SizedBox();

        int minCol = visibleTiles.map((t) => t.col).reduce((a, b) => a < b ? a : b);
        int maxCol = visibleTiles.map((t) => t.col).reduce((a, b) => a > b ? a : b);
        int minRow = visibleTiles.map((t) => t.row).reduce((a, b) => a < b ? a : b);
        int maxRow = visibleTiles.map((t) => t.row).reduce((a, b) => a > b ? a : b);

        // Tile size based on available space
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        final boardCols = (maxCol - minCol) / 2 + 1;
        final boardRows = (maxRow - minRow) / 2 + 1;

        // Available space for board
        const vertPadding = 240.0; // header + controls
        final availW = screenWidth - 24;
        final availH = screenHeight - vertPadding;

        final tileW = (availW / boardCols).clamp(32.0, 56.0);
        final tileH = tileW * 1.25;
        final actualW = tileW.clamp(32.0, 56.0);
        final actualH = actualW * 1.25;

        // Layer offset for 3D
        const layerOffsetX = 3.0;
        const layerOffsetY = -3.0;

        // Sort tiles by layer (bottom first) for correct overlap
        final sortedTiles = List<MahjongTile>.from(game.tiles)
          ..sort((a, b) {
            if (a.layer != b.layer) return a.layer.compareTo(b.layer);
            return (a.row + a.col).compareTo(b.row + b.col);
          });

        final freeTileIds = Set<String>.from(game.freeTiles.map((t) => t.id));
        final hintIds = Set<String>.from(
          (game.hintPair ?? []).map((t) => t.id),
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: boardCols * actualW + 40,
                  height: boardRows * actualH + 40,
                  child: Stack(
                    children: sortedTiles
                        .where((t) => t.isVisible)
                        .map((tile) {
                      final x = ((tile.col - minCol) / 2) * actualW +
                          tile.layer * layerOffsetX + 12;
                      final y = ((tile.row - minRow) / 2) * actualH +
                          tile.layer * layerOffsetY + 12;

                      return Positioned(
                        left: x,
                        top: y,
                        child: TileWidget(
                          tile: tile,
                          isFree: freeTileIds.contains(tile.id),
                          isHinted: hintIds.contains(tile.id),
                          tileWidth: actualW,
                          tileHeight: actualH,
                          onTap: () => game.selectTile(tile),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}