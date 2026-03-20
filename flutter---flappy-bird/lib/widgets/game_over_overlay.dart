import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

class GameOverOverlay extends StatefulWidget {
  final int score;
  final int highScore;
  final bool isNewHighScore;
  final int? leaderboardRank;
  final VoidCallback onRestart;
  final VoidCallback onLeaderboard;

  const GameOverOverlay({
    super.key,
    required this.score,
    required this.highScore,
    required this.isNewHighScore,
    this.leaderboardRank,
    required this.onRestart,
    required this.onLeaderboard,
  });

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Container(
        color: AppTheme.deepPlumBg.withOpacity(0.82),
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: _buildCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 36),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.midPlum, AppTheme.plum, AppTheme.deepPlumBg],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.hotPink.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.hotPink.withOpacity(0.25),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('💀', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 8),
          Text(
            'GAME OVER',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppTheme.hotPink,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 20),
          if (widget.isNewHighScore)
            _NewHighScoreBadge(),
          if (widget.leaderboardRank != null && widget.leaderboardRank! <= 10)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _RankBadge(rank: widget.leaderboardRank!),
            ),
          const SizedBox(height: 16),
          _ScoreRow(label: 'Score', value: widget.score, highlight: true),
          const SizedBox(height: 8),
          _ScoreRow(label: 'Best', value: widget.highScore, highlight: false),
          const SizedBox(height: 28),
          _RestartButton(onTap: widget.onRestart),
          const SizedBox(height: 10),
          // Leaderboard shortcut
          GestureDetector(
            onTap: widget.onLeaderboard,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.leaderboard_rounded,
                    color: AppTheme.plumPale, size: 14),
                const SizedBox(width: 5),
                Text(
                  'View Leaderboard',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppTheme.plumPale,
                      decoration: TextDecoration.underline,
                      decorationColor: AppTheme.plumPale,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap anywhere to play again',
            style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppTheme.plumPale.withOpacity(0.6),
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

class _NewHighScoreBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppTheme.goldAccent, Color(0xFFFFAA00)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppTheme.goldAccent.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 1)
        ],
      ),
      child: Text(
        '🏆 NEW HIGH SCORE!',
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppTheme.deepPlumBg,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final int value;
  final bool highlight;
  const _ScoreRow(
      {required this.label, required this.value, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 15,
                color: AppTheme.plumPale,
                fontWeight: FontWeight.w500)),
        Text('$value',
            style: GoogleFonts.poppins(
                fontSize: 22,
                color: highlight ? AppTheme.rosePink : Colors.white,
                fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _RestartButton extends StatefulWidget {
  final VoidCallback onTap;
  const _RestartButton({required this.onTap});

  @override
  State<_RestartButton> createState() => _RestartButtonState();
}

class _RestartButtonState extends State<_RestartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) {
        final glow = _pulse.value * 0.3;
        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.hotPink, AppTheme.rosePink],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.hotPink.withOpacity(0.35 + glow),
                  blurRadius: 16 + glow * 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.replay_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'PLAY AGAIN',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RankBadge extends StatelessWidget {
  final int rank;
  const _RankBadge({required this.rank});

  String get _medal {
    if (rank == 1) return '🥇';
    if (rank == 2) return '🥈';
    if (rank == 3) return '🥉';
    return '🏅';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.midPlum.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.plumPale.withOpacity(0.4)),
      ),
      child: Text(
        '$_medal Leaderboard Rank #$rank',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.blushPink,
        ),
      ),
    );
  }
}
