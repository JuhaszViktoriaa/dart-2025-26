# 🐦 Flappy Bird — Plum Sky Edition  
**v2.0 — Full Feature Release**

A fully-featured Flappy Bird clone in **Flutter** with a red-pink & CSS plum aesthetic.  
No Firebase. No backend. Fully offline.

---

## ✨ What's Included

| Feature | Details |
|---|---|
| 🎮 Physics gameplay | Gravity, velocity, rotation, pipe spawning |
| 📈 Progressive difficulty | Speed & gap scale with score |
| 🐦 Animated bird | 3-frame wing flap animation (up / mid / down) |
| 🔊 Sound effects | Flap, score, die, swoosh via `audioplayers` |
| 🏆 Leaderboard | Top 10 local scores with name, rank, medals, timestamps |
| ⚙️ Settings | Sound, music, vibration, difficulty (Easy/Normal/Hard), player name |
| 💀 Game Over | Animated card, high score detection, leaderboard rank badge |
| ⏸ Pause / Resume | Mid-game pause with menu for Settings & Leaderboard |
| 📱 Portrait lock | Optimised for all phone sizes |

---

## 🚀 Quick Start

```bash
cd flappy_bird
flutter pub get
flutter run
```

Release builds:
```bash
flutter build apk --release   # Android
flutter build ipa --release   # iOS (Xcode required)
```

---

## 🔊 Adding Sound Effects (Optional)

The game works silently without audio files. To enable sounds, add WAV files to `assets/audio/`:

| File | Trigger |
|---|---|
| `flap.wav` | Every tap / wing flap |
| `score.wav` | Passing through a pipe gap |
| `die.wav` | Collision / game over |
| `swoosh.wav` | Game start |

Free sources: [freesound.org](https://freesound.org), [kenney.nl/assets](https://kenney.nl/assets)

---

## 🗂 Project Structure

```
lib/
├── main.dart
├── game/
│   ├── game_engine.dart       # Physics, collision, sound hooks, difficulty
│   └── game_state.dart        # Data model (bird frame, rank, etc.)
├── screens/
│   ├── home_screen.dart       # Entry router
│   ├── game_screen.dart       # Main scaffold — wires engine + overlays
│   ├── settings_screen.dart   # Sound, music, difficulty, player name
│   └── leaderboard_screen.dart# Animated top-10 with medals
├── widgets/
│   ├── game_painter.dart      # CustomPainter — animated bird, pipes, sky
│   ├── score_hud.dart         # Live score + best
│   ├── idle_overlay.dart      # Start screen with nav icons
│   └── game_over_overlay.dart # Score card + rank badge
└── utils/
    ├── app_theme.dart          # Plum & rose-pink palette
    ├── game_constants.dart     # All tunable physics values
    ├── score_manager.dart      # Personal high score (SharedPrefs)
    ├── leaderboard_manager.dart# Top-10 JSON store (SharedPrefs)
    ├── settings_manager.dart   # All settings + difficulty multipliers
    └── sound_service.dart      # AudioPlayers wrapper (graceful no-op)
```

---

## 🎨 Color Palette

| Name | Hex | Usage |
|---|---|---|
| Deep Plum BG | `#3D0B22` | Sky / scaffold background |
| Mid Plum | `#5C1035` | Cards, UI surfaces |
| Plum | `#8B1A4A` | Pipes, gradients |
| Hot Pink | `#FF1A6C` | Bird body, primary CTA |
| Rose Pink | `#FF4D8D` | Highlights, score |
| Blush Pink | `#FFB3D1` | Stars, labels |
| Gold | `#FFD700` | Score badge, beak, rank #1 |

---

## 🕹 Controls

| Action | Control |
|---|---|
| Flap | Tap anywhere |
| Pause | ⏸ button (top-right during play) |
| Settings | ⚙️ icon (home screen or pause menu) |
| Leaderboard | 🏆 icon (home screen, pause menu, game over) |

---

## ⚙️ Difficulty Tuning

| Mode | Gravity | Speed | Gap |
|---|---|---|---|
| 🌸 Easy | ×0.75 | ×0.75 | ×1.25 |
| 🌺 Normal | ×1.0 | ×1.0 | ×1.0 |
| 🔥 Hard | ×1.35 | ×1.4 | ×0.75 |

Raw values in `lib/utils/game_constants.dart`.

---

## 📦 Dependencies

```yaml
shared_preferences: ^2.2.2   # Scores, settings, leaderboard
google_fonts: ^6.1.0          # Poppins font
audioplayers: ^5.2.1          # Sound effects
flutter_animate: ^4.5.0       # UI animation helpers
```

Zero Firebase. Zero network. Fully offline.

---

## 📝 License

MIT — use, modify, distribute freely.
