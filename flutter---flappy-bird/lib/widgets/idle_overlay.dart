import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

class IdleOverlay extends StatefulWidget {
  final VoidCallback onSettings;
  final VoidCallback onLeaderboard;

  const IdleOverlay({
    super.key,
    required this.onSettings,
    required this.onLeaderboard,
  });

  @override
  State<IdleOverlay> createState() => _IdleOverlayState();
}

class _IdleOverlayState extends State<IdleOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounce;
  late final Animation<double> _offsetY;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100))
      ..repeat(reverse: true);
    _offsetY = Tween<double>(begin: -6, end: 6).animate(
        CurvedAnimation(parent: _bounce, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top-right nav buttons
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _NavIcon(
                    icon: Icons.leaderboard_rounded,
                    onTap: widget.onLeaderboard,
                    tooltip: 'Leaderboard',
                  ),
                  const SizedBox(width: 8),
                  _NavIcon(
                    icon: Icons.settings_rounded,
                    onTap: widget.onSettings,
                    tooltip: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
        // Main content
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🐦', style: TextStyle(fontSize: 52)),
              const SizedBox(height: 6),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppTheme.hotPink, AppTheme.blushPink, AppTheme.rosePink],
                ).createShader(bounds),
                child: Text(
                  'FLAPPY BIRD',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'in the Plum Sky',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppTheme.plumPale,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 36),
              AnimatedBuilder(
                animation: _offsetY,
                builder: (_, child) => Transform.translate(
                  offset: Offset(0, _offsetY.value),
                  child: child,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.hotPink, AppTheme.plumLight],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.hotPink.withOpacity(0.45),
                        blurRadius: 18,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.touch_app_rounded,
                          color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'TAP TO START',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _HowToPlay(),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  const _NavIcon(
      {required this.icon, required this.onTap, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: AppTheme.midPlum.withOpacity(0.65),
            shape: BoxShape.circle,
            border: Border.all(
                color: AppTheme.plumPale.withOpacity(0.35), width: 1.5),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _HowToPlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.midPlum.withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.plumPale.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            'HOW TO PLAY',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.blushPink,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          _tip('👆', 'Tap to flap your wings'),
          _tip('🚧', 'Dodge the pink pipes'),
          _tip('⭐', 'Earn a point for each gap'),
        ],
      ),
    );
  }

  Widget _tip(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppTheme.cream,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
