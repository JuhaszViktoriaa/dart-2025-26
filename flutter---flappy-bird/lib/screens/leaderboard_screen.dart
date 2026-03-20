import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../utils/leaderboard_manager.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  List<LeaderboardEntry> _entries = [];
  bool _loading = true;
  late AnimationController _stagger;

  @override
  void initState() {
    super.initState();
    _stagger = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _load();
  }

  Future<void> _load() async {
    final entries = await LeaderboardManager.getEntries();
    if (mounted) {
      setState(() {
        _entries = entries;
        _loading = false;
      });
      _stagger.forward();
    }
  }

  Future<void> _confirmClear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.midPlum,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Clear Leaderboard?',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w700)),
        content: Text('All scores will be permanently deleted.',
            style: GoogleFonts.poppins(color: AppTheme.plumPale)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: AppTheme.plumPale)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Clear',
                style: GoogleFonts.poppins(
                    color: AppTheme.hotPink, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await LeaderboardManager.clearAll();
      _stagger.reset();
      _load();
    }
  }

  @override
  void dispose() {
    _stagger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepPlumBg,
      appBar: AppBar(
        backgroundColor: AppTheme.midPlum,
        title: Text('Leaderboard',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, color: Colors.white)),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_entries.isNotEmpty)
            IconButton(
              icon:
                  const Icon(Icons.delete_outline_rounded, color: AppTheme.plumPale),
              tooltip: 'Clear all',
              onPressed: _confirmClear,
            ),
        ],
        elevation: 0,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.hotPink))
          : _entries.isEmpty
              ? _EmptyState()
              : _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      itemCount: _entries.length,
      itemBuilder: (ctx, i) {
        final delay = i * 0.08;
        final animation = CurvedAnimation(
          parent: _stagger,
          curve: Interval(delay.clamp(0.0, 0.9), (delay + 0.4).clamp(0.0, 1.0),
              curve: Curves.easeOutBack),
        );
        return AnimatedBuilder(
          animation: animation,
          builder: (_, child) => Opacity(
            opacity: animation.value.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - animation.value)),
              child: child,
            ),
          ),
          child: _EntryCard(entry: _entries[i], rank: i + 1),
        );
      },
    );
  }
}

class _EntryCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;

  const _EntryCard({required this.entry, required this.rank});

  String get _medal {
    if (rank == 1) return '🥇';
    if (rank == 2) return '🥈';
    if (rank == 3) return '🥉';
    return '$rank';
  }

  Color get _rankColor {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return AppTheme.plumPale;
  }

  bool get _isTopThree => rank <= 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: _isTopThree
            ? LinearGradient(
                colors: [
                  AppTheme.midPlum.withOpacity(0.9),
                  AppTheme.plum.withOpacity(0.6),
                ],
              )
            : null,
        color: _isTopThree ? null : AppTheme.midPlum.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isTopThree
              ? _rankColor.withOpacity(0.5)
              : AppTheme.plumPale.withOpacity(0.15),
          width: _isTopThree ? 1.5 : 1,
        ),
        boxShadow: _isTopThree
            ? [
                BoxShadow(
                  color: _rankColor.withOpacity(0.12),
                  blurRadius: 12,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Row(
        children: [
          // Rank badge
          SizedBox(
            width: 36,
            child: rank <= 3
                ? Text(_medal, style: const TextStyle(fontSize: 24))
                : Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.plum.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$rank',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.plumPale),
                    ),
                  ),
          ),
          const SizedBox(width: 14),
          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatDate(entry.date),
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppTheme.plumPale),
                ),
              ],
            ),
          ),
          // Score
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              gradient: _isTopThree
                  ? LinearGradient(
                      colors: [_rankColor.withOpacity(0.8), _rankColor])
                  : null,
              color: _isTopThree ? null : AppTheme.plum.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${entry.score}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: _isTopThree ? AppTheme.deepPlumBg : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${d.day}/${d.month}/${d.year}';
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🏆', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text('No scores yet!',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Text('Play a game to get on the board.',
              style: GoogleFonts.poppins(
                  fontSize: 14, color: AppTheme.plumPale)),
        ],
      ),
    );
  }
}
