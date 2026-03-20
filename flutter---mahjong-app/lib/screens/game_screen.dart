import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_provider.dart';
import '../models/game_state.dart';
import '../theme/app_theme.dart';
import '../widgets/game_board.dart';
import '../widgets/game_hud.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        return Stack(
          children: [
            // Background
            Container(decoration: AppTheme.backgroundDecoration),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // HUD at top
                  const GameHUD(),
                  // Board
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.surface.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: const GameBoard(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Overlay dialogs
            if (game.status == GameStatus.paused)
              _PauseOverlay(game: game),
            if (game.status == GameStatus.won)
              _WinOverlay(game: game),
            if (game.status == GameStatus.noMoves)
              _NoMovesOverlay(game: game),
          ],
        );
      },
    );
  }
}

class _PauseOverlay extends StatelessWidget {
  final GameProvider game;
  const _PauseOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    return _Overlay(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pause_circle_outline_rounded, size: 64, color: AppTheme.primaryLight),
          const SizedBox(height: 16),
          const Text('PAUSED', style: TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimary, letterSpacing: 4,
          )),
          const SizedBox(height: 8),
          Text(
            'Score: ${game.score}  |  Time: ${game.formattedTime}',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: game.resumeGame,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('RESUME'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: game.returnToMenu,
            child: const Text('Return to Menu', style: TextStyle(color: AppTheme.textMuted)),
          ),
        ],
      ),
    );
  }
}

class _WinOverlay extends StatelessWidget {
  final GameProvider game;
  const _WinOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    return _Overlay(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(
              colors: [AppTheme.primaryLight, AppTheme.matchedGlow],
            ).createShader(b),
            child: const Text(
              'YOU WIN!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 3),
            ),
          ),
          const SizedBox(height: 20),
          _ResultRow(Icons.star_rounded, 'Final Score', '${game.score}', AppTheme.matchedGlow),
          const SizedBox(height: 8),
          _ResultRow(Icons.timer_rounded, 'Time', game.formattedTime, AppTheme.primaryLight),
          const SizedBox(height: 8),
          _ResultRow(Icons.map_rounded, 'Layout', game.currentLayout.name, AppTheme.accentWarm),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: game.startGame,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('PLAY AGAIN'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: game.returnToMenu,
            child: const Text('Main Menu', style: TextStyle(color: AppTheme.textMuted)),
          ),
        ],
      ),
    );
  }
}

class _NoMovesOverlay extends StatelessWidget {
  final GameProvider game;
  const _NoMovesOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    return _Overlay(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('😔', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          const Text('NO MORE MOVES', style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary, letterSpacing: 2,
          )),
          const SizedBox(height: 8),
          Text(
            'Score: ${game.score}',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '${game.remainingTiles} tiles remaining',
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 28),
          if (game.shufflesRemaining > 0)
            ElevatedButton.icon(
              onPressed: () {
                game.useShuffle();
              },
              icon: const Icon(Icons.shuffle_rounded),
              label: Text('SHUFFLE (${game.shufflesRemaining} left)'),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryLight),
            ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: game.startGame,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('NEW GAME'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: game.returnToMenu,
            child: const Text('Main Menu', style: TextStyle(color: AppTheme.textMuted)),
          ),
        ],
      ),
    );
  }
}

class _Overlay extends StatelessWidget {
  final Widget child;
  const _Overlay({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppTheme.surfaceElevated,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.primary.withOpacity(0.4), width: 1.5),
            boxShadow: [
              BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 30, spreadRadius: 2),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ResultRow(this.icon, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
        Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}