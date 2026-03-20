import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/board_layout.dart';
import '../services/game_provider.dart';
import '../theme/app_theme.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        return Container(
          decoration: AppTheme.backgroundDecoration,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Logo / Title
                  _buildLogo(),
                  const SizedBox(height: 40),
                  // Layout selector
                  _buildLayoutSelector(context, game),
                  const SizedBox(height: 32),
                  // Play button
                  _buildPlayButton(context, game),
                  const SizedBox(height: 24),
                  // Stats row
                  _buildStatsRow(game),
                  const SizedBox(height: 24),
                  // High scores
                  _buildHighScores(game),
                  const SizedBox(height: 16),
                  // Reset button
                  TextButton.icon(
                    onPressed: () => _confirmReset(context, game),
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text('Reset Stats', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // Decorative tiles
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MiniTile('🀄', AppTheme.accent),
            const SizedBox(width: 8),
            _MiniTile('🎋', AppTheme.tileGreen),
            const SizedBox(width: 8),
            _MiniTile('中', AppTheme.tileRed),
            const SizedBox(width: 8),
            _MiniTile('🌸', const Color(0xFFE91E8C)),
          ],
        ),
        const SizedBox(height: 20),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppTheme.primaryLight, AppTheme.accent, AppTheme.accentWarm],
          ).createShader(bounds),
          child: const Text(
            '麻将',
            style: TextStyle(
              fontSize: 56,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
        ),
        const Text(
          'MAHJONG SOLITAIRE',
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondary,
            letterSpacing: 6,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildLayoutSelector(BuildContext context, GameProvider game) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'CHOOSE LAYOUT',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: BoardLayouts.all.map((layout) {
            final isSelected = game.currentLayout.name == layout.name;
            return Expanded(
              child: GestureDetector(
                onTap: () => game.setLayout(layout),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary.withOpacity(0.2)
                        : AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppTheme.primary : Colors.white.withOpacity(0.1),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 12)]
                        : null,
                  ),
                  child: Column(
                    children: [
                      Text(layout.emoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 6),
                      Text(
                        layout.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppTheme.primaryLight : AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          layout.difficulty,
                          (i) => const Icon(Icons.star_rounded, size: 10, color: AppTheme.matchedGlow),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${layout.tileCount} tiles',
                        style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPlayButton(BuildContext context, GameProvider game) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => game.startGame(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 12,
          shadowColor: AppTheme.primary.withOpacity(0.6),
        ).copyWith(
          overlayColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_arrow_rounded, size: 28),
            const SizedBox(width: 8),
            Text(
              'PLAY ${game.currentLayout.name.toUpperCase()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(GameProvider game) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem('Games', '${game.stats.gamesPlayed}', Icons.grid_view_rounded),
          _divider(),
          _StatItem('Won', '${game.stats.gamesWon}', Icons.emoji_events_rounded),
          _divider(),
          _StatItem(
            'Win Rate',
            '${game.stats.winRate.toStringAsFixed(0)}%',
            Icons.trending_up_rounded,
          ),
          _divider(),
          _StatItem(
            'Best',
            game.stats.bestTime == 0
                ? '—'
                : '${game.stats.bestTime ~/ 60}:${(game.stats.bestTime % 60).toString().padLeft(2, '0')}',
            Icons.timer_outlined,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    width: 1, height: 32,
    color: Colors.white.withOpacity(0.1),
  );

  Widget _buildHighScores(GameProvider game) {
    if (game.highScores.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'HIGH SCORES',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...game.highScores.take(5).toList().asMap().entries.map((entry) {
          final i = entry.key;
          final score = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: i == 0 ? AppTheme.matchedGlow.withOpacity(0.08) : AppTheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: i == 0
                    ? AppTheme.matchedGlow.withOpacity(0.3)
                    : Colors.white.withOpacity(0.06),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: i == 0 ? AppTheme.matchedGlow : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(width: 12),
                if (i == 0) const Icon(Icons.emoji_events_rounded, size: 16, color: AppTheme.matchedGlow),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    score.layout,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                ),
                Text(
                  '${score.score}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: i == 0 ? AppTheme.matchedGlow : AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${score.time ~/ 60}:${(score.time % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _confirmReset(BuildContext context, GameProvider game) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surfaceElevated,
        title: const Text('Reset Stats', style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text(
          'This will delete all your stats and high scores.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              game.resetStats();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _MiniTile extends StatelessWidget {
  final String symbol;
  final Color color;

  const _MiniTile(this.symbol, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8)],
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Center(
        child: Text(symbol, style: TextStyle(fontSize: 18, color: color)),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryLight),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary,
        )),
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
      ],
    );
  }
}