import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../game/game_engine.dart';
import '../game/game_state.dart';
import '../widgets/game_painter.dart';
import '../widgets/score_hud.dart';
import '../widgets/game_over_overlay.dart';
import '../widgets/idle_overlay.dart';
import '../utils/app_theme.dart';
import 'settings_screen.dart';
import 'leaderboard_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late final GameEngine _engine;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _engine = GameEngine();
    _ticker = Ticker((_) => _engine.tick())..start();
    _engine.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ticker.dispose();
    _engine.dispose();
    super.dispose();
  }

  Future<void> _openSettings() async {
    _engine.togglePause();
    final reload = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
    if (reload == true) await _engine.reloadSettings();
    if (mounted && _engine.state.status == GameStatus.paused) {
      _engine.togglePause(); // resume
    }
  }

  void _openLeaderboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _engine.setScreenSize(size.width, size.height);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _engine.tap,
      child: Scaffold(
        backgroundColor: AppTheme.deepPlumBg,
        body: Stack(
          children: [
            // ── Game canvas ───────────────────────────────────────────────
            CustomPaint(
              painter: GamePainter(
                state: _engine.state,
                screenWidth: size.width,
                screenHeight: size.height,
              ),
              size: size,
            ),

            // ── Score HUD ─────────────────────────────────────────────────
            if (_engine.state.status == GameStatus.playing ||
                _engine.state.status == GameStatus.gameOver)
              SafeArea(
                child: ScoreHud(
                  score: _engine.state.score,
                  highScore: _engine.state.highScore,
                ),
              ),

            // ── Pause button ──────────────────────────────────────────────
            if (_engine.state.status == GameStatus.playing)
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                right: 16,
                child: _PauseButton(onTap: _engine.togglePause),
              ),

            // ── Idle overlay ──────────────────────────────────────────────
            if (_engine.state.status == GameStatus.idle)
              IdleOverlay(
                onSettings: _openSettings,
                onLeaderboard: _openLeaderboard,
              ),

            // ── Paused overlay ────────────────────────────────────────────
            if (_engine.state.status == GameStatus.paused)
              _PausedOverlay(
                onResume: _engine.togglePause,
                onSettings: _openSettings,
                onLeaderboard: _openLeaderboard,
              ),

            // ── Game Over overlay ─────────────────────────────────────────
            if (_engine.state.status == GameStatus.gameOver)
              GameOverOverlay(
                score: _engine.state.score,
                highScore: _engine.state.highScore,
                isNewHighScore: _engine.state.isNewHighScore,
                leaderboardRank: _engine.state.leaderboardRank,
                onRestart: _engine.startGame,
                onLeaderboard: _openLeaderboard,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _PauseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _PauseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.midPlum.withOpacity(0.7),
          shape: BoxShape.circle,
          border: Border.all(
              color: AppTheme.plumPale.withOpacity(0.4), width: 1.5),
        ),
        child: const Icon(Icons.pause_rounded, color: Colors.white, size: 22),
      ),
    );
  }
}

class _PausedOverlay extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onSettings;
  final VoidCallback onLeaderboard;
  const _PausedOverlay(
      {required this.onResume,
      required this.onSettings,
      required this.onLeaderboard});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.deepPlumBg.withOpacity(0.80),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pause_circle_filled_rounded,
                color: AppTheme.hotPink, size: 72),
            const SizedBox(height: 12),
            Text('PAUSED',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppTheme.blushPink,
                      letterSpacing: 4,
                    )),
            const SizedBox(height: 28),
            _MenuButton(
              icon: Icons.play_arrow_rounded,
              label: 'Resume',
              color: AppTheme.hotPink,
              onTap: onResume,
            ),
            const SizedBox(height: 12),
            _MenuButton(
              icon: Icons.leaderboard_rounded,
              label: 'Leaderboard',
              color: AppTheme.plumLight,
              onTap: onLeaderboard,
            ),
            const SizedBox(height: 12),
            _MenuButton(
              icon: Icons.settings_rounded,
              label: 'Settings',
              color: AppTheme.plum,
              onTap: onSettings,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MenuButton(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)),
          elevation: 3,
        ),
      ),
    );
  }
}
