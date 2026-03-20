import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../utils/settings_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _sound = true;
  bool _music = true;
  bool _vibration = true;
  Difficulty _difficulty = Difficulty.normal;
  late TextEditingController _nameCtrl;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _load();
  }

  Future<void> _load() async {
    final sound = await SettingsManager.getSoundEnabled();
    final music = await SettingsManager.getMusicEnabled();
    final vib   = await SettingsManager.getVibrationEnabled();
    final diff  = await SettingsManager.getDifficulty();
    final name  = await SettingsManager.getPlayerName();
    if (mounted) {
      setState(() {
        _sound = sound; _music = music; _vibration = vib;
        _difficulty = diff;
        _nameCtrl.text = name;
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    await SettingsManager.setSoundEnabled(_sound);
    await SettingsManager.setMusicEnabled(_music);
    await SettingsManager.setVibrationEnabled(_vibration);
    await SettingsManager.setDifficulty(_difficulty);
    await SettingsManager.setPlayerName(_nameCtrl.text.trim());
    if (mounted) Navigator.pop(context, true); // true = reload needed
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepPlumBg,
      appBar: AppBar(
        backgroundColor: AppTheme.midPlum,
        title: Text('Settings',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('Save',
                style: GoogleFonts.poppins(
                    color: AppTheme.rosePink,
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
          ),
        ],
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.hotPink))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader('👤 Player'),
                  _Card(child: _nameField()),
                  const SizedBox(height: 20),
                  _SectionHeader('🎚 Difficulty'),
                  _Card(child: _difficultyPicker()),
                  const SizedBox(height: 20),
                  _SectionHeader('🔊 Audio'),
                  _Card(
                    child: Column(children: [
                      _ToggleRow(
                        icon: Icons.volume_up_rounded,
                        label: 'Sound Effects',
                        value: _sound,
                        onChanged: (v) => setState(() => _sound = v),
                      ),
                      _Divider(),
                      _ToggleRow(
                        icon: Icons.music_note_rounded,
                        label: 'Music',
                        value: _music,
                        onChanged: (v) => setState(() => _music = v),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  _SectionHeader('📳 Haptics'),
                  _Card(
                    child: _ToggleRow(
                      icon: Icons.vibration_rounded,
                      label: 'Vibration',
                      value: _vibration,
                      onChanged: (v) => setState(() => _vibration = v),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _saveButton(),
                ],
              ),
            ),
    );
  }

  Widget _nameField() {
    return TextField(
      controller: _nameCtrl,
      maxLength: 18,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_ ]'))],
      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: 'Display Name',
        labelStyle: GoogleFonts.poppins(color: AppTheme.plumPale),
        prefixIcon: const Icon(Icons.person_rounded, color: AppTheme.rosePink),
        counterStyle: GoogleFonts.poppins(color: AppTheme.plumPale, fontSize: 11),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.plumPale.withOpacity(0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.hotPink, width: 2),
        ),
        filled: true,
        fillColor: AppTheme.midPlum.withOpacity(0.3),
      ),
    );
  }

  Widget _difficultyPicker() {
    return Column(
      children: Difficulty.values.map((d) {
        final selected = _difficulty == d;
        return GestureDetector(
          onTap: () => setState(() => _difficulty = d),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: selected
                  ? const LinearGradient(
                      colors: [AppTheme.hotPink, AppTheme.plumLight])
                  : null,
              color: selected ? null : AppTheme.midPlum.withOpacity(0.35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? AppTheme.hotPink
                    : AppTheme.plumPale.withOpacity(0.25),
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Text(_diffEmoji(d), style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_diffLabel(d),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 14)),
                      Text(_diffDesc(d),
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: selected
                                  ? Colors.white70
                                  : AppTheme.plumPale)),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 20),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _diffEmoji(Difficulty d) {
    switch (d) {
      case Difficulty.easy:   return '🌸';
      case Difficulty.normal: return '🌺';
      case Difficulty.hard:   return '🔥';
    }
  }

  String _diffLabel(Difficulty d) {
    switch (d) {
      case Difficulty.easy:   return 'Easy — Relaxed';
      case Difficulty.normal: return 'Normal — Classic';
      case Difficulty.hard:   return 'Hard — Expert';
    }
  }

  String _diffDesc(Difficulty d) {
    switch (d) {
      case Difficulty.easy:   return 'Wider gaps, slower pipes, light gravity';
      case Difficulty.normal: return 'The original Flappy Bird experience';
      case Difficulty.hard:   return 'Narrow gaps, fast pipes, heavy gravity';
    }
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _save,
        icon: const Icon(Icons.check_rounded, color: Colors.white),
        label: Text('Save & Return',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.hotPink,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: AppTheme.hotPink.withOpacity(0.4),
        ),
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(text,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.blushPink,
                letterSpacing: 1)),
      );
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.midPlum.withOpacity(0.45),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.plumPale.withOpacity(0.2)),
        ),
        child: child,
      );
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: AppTheme.rosePink, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14)),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.hotPink,
            activeTrackColor: AppTheme.plumLight,
          ),
        ],
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(
      height: 16, thickness: 1, color: AppTheme.plumPale.withOpacity(0.15));
}
