import 'package:flutter/material.dart';
import '../models/tile.dart';
import '../theme/app_theme.dart';

class TileWidget extends StatefulWidget {
  final MahjongTile tile;
  final bool isFree;
  final bool isHinted;
  final VoidCallback? onTap;
  final double tileWidth;
  final double tileHeight;

  const TileWidget({
    super.key,
    required this.tile,
    required this.isFree,
    this.isHinted = false,
    this.onTap,
    this.tileWidth = 48,
    this.tileHeight = 60,
  });

  @override
  State<TileWidget> createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isFree || widget.onTap == null) return;
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap!();
  }

  BoxDecoration get _decoration {
    if (widget.isHinted) return AppTheme.hintCardDecoration;
    switch (widget.tile.state) {
      case TileState.selected: return AppTheme.selectedCardDecoration;
      case TileState.matched: return AppTheme.matchedCardDecoration;
      default: return AppTheme.cardDecoration;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBlocked = !widget.isFree;

    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.tileWidth,
          height: widget.tileHeight,
          decoration: isBlocked
              ? BoxDecoration(
                  color: const Color(0xFFDCC8CE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.cardShadow.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(2, 3),
                    ),
                  ],
                )
              : _decoration,
          child: Stack(
            children: [
              // 3D depth effect - left edge
              if (!isBlocked) ...[
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
                // Bottom edge shadow
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppTheme.cardShadow.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],

              // Tile content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Main symbol
                    Text(
                      widget.tile.displaySymbol,
                      style: TextStyle(
                        fontSize: widget.tileWidth * 0.45,
                        color: isBlocked
                            ? widget.tile.symbolColor.withOpacity(0.4)
                            : widget.tile.symbolColor,
                      ),
                    ),
                    // Suit label
                    if (widget.tileWidth > 40)
                      Text(
                        widget.tile.suitLabel,
                        style: TextStyle(
                          fontSize: 7,
                          color: isBlocked
                              ? AppTheme.textMuted.withOpacity(0.4)
                              : AppTheme.textMuted,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                  ],
                ),
              ),

              // Value indicator (top-left corner)
              if (widget.tile.suit != TileSuit.flowers &&
                  widget.tile.suit != TileSuit.seasons &&
                  widget.tile.suit != TileSuit.winds &&
                  widget.tile.suit != TileSuit.dragons)
                Positioned(
                  top: 3,
                  left: 4,
                  child: Text(
                    '${widget.tile.value}',
                    style: TextStyle(
                      fontSize: 9,
                      color: isBlocked
                          ? widget.tile.accentColor.withOpacity(0.4)
                          : widget.tile.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // Layer indicator (tiny dots top-right)
              if (widget.tile.layer > 0)
                Positioned(
                  top: 3,
                  right: 4,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      widget.tile.layer,
                      (i) => Container(
                        width: 3,
                        height: 3,
                        margin: const EdgeInsets.only(left: 1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isBlocked
                              ? AppTheme.primaryLight.withOpacity(0.3)
                              : AppTheme.primaryLight.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ),

              // Glow overlay for special states
              if (widget.tile.state == TileState.matched)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.matchedGlow.withOpacity(0.15),
                  ),
                ),

              // Blocked overlay
              if (isBlocked)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(0.15),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
