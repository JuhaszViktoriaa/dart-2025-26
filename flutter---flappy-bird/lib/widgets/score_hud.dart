import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

class ScoreHud extends StatelessWidget {
  final int score;
  final int highScore;

  const ScoreHud({super.key, required this.score, required this.highScore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ScorePill(label: 'BEST', value: highScore, icon: '🏆'),
          _CurrentScore(score: score),
          const SizedBox(width: 72), // balance
        ],
      ),
    );
  }
}

class _CurrentScore extends StatelessWidget {
  final int score;
  const _CurrentScore({required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.hotPink, AppTheme.plumLight],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.hotPink.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        '$score',
        style: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1.1,
        ),
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  final String label;
  final int value;
  final String icon;
  const _ScorePill(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.midPlum.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.plumPale.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 9,
                      color: AppTheme.blushPink,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2)),
              Text('$value',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}
