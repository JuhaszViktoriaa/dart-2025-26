import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_provider.dart';
import '../theme/app_theme.dart';

class GameHUD extends StatelessWidget {
  const GameHUD({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.surface.withOpacity(0.95),
                AppTheme.surface.withOpacity(0.0),
              ],
            ),
          ),
          child: Column(
            children: [
              // Top row: score, time, tiles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatChip(
                    icon: Icons.star_rounded,
                    label: 'Score',
                    value: _formatScore(game.score),
                    color: AppTheme.matchedGlow,
                  ),
                  _StatChip(
                    icon: Icons.timer_rounded,
                    label: 'Time',
                    value: game.formattedTime,
                    color: AppTheme.primaryLight,
                  ),
                  _StatChip(
                    icon: Icons.dashboard_rounded,
                    label: 'Tiles',
                    value: '${game.remainingTiles}/${game.totalTiles}',
                    color: AppTheme.accentWarm,
                  ),
                  if (game.comboMultiplier > 1)
                    _StatChip(
                      icon: Icons.bolt_rounded,
                      label: 'Combo',
                      value: '×${game.comboMultiplier}',
                      color: AppTheme.accent,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    icon: Icons.lightbulb_rounded,
                    label: 'Hint',
                    badge: '${game.hintsRemaining}',
                    onTap: game.hintsRemaining > 0 ? game.useHint : null,
                    color: AppTheme.hintGlow,
                  ),
                  _ActionButton(
                    icon: Icons.shuffle_rounded,
                    label: 'Shuffle',
                    badge: '${game.shufflesRemaining}',
                    onTap: game.shufflesRemaining > 0 ? game.useShuffle : null,
                    color: AppTheme.primaryLight,
                  ),
                  _ActionButton(
                    icon: Icons.undo_rounded,
                    label: 'Undo',
                    badge: null,
                    onTap: game.canUndo ? game.undoLastMove : null,
                    color: AppTheme.accentWarm,
                  ),
                  _ActionButton(
                    icon: Icons.pause_circle_rounded,
                    label: 'Pause',
                    badge: null,
                    onTap: game.pauseGame,
                    color: AppTheme.textSecondary,
                  ),
                ],
              ),
              // Progress bar
              const SizedBox(height: 8),
              _ProgressBar(
                progress: game.totalTiles == 0
                    ? 0
                    : 1 - (game.remainingTiles / game.totalTiles),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatScore(int score) {
    if (score >= 1000) return '${(score / 1000).toStringAsFixed(1)}k';
    return '$score';
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: color.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback? onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.badge,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: enabled ? color.withOpacity(0.15) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled ? color.withOpacity(0.4) : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: enabled ? color : color.withOpacity(0.3)),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    color: enabled ? color : color.withOpacity(0.3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (badge != null && enabled)
              Positioned(
                top: -6,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryLight, AppTheme.accent],
            ),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accent.withOpacity(0.5),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}