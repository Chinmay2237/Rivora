# Rivora — Virtual Musical Instruments

**Rivora** is a premium, landscape-first virtual musical instrument application built with Flutter. It features a full 10-piece interactive acoustic drum kit and a 7-note acoustic xylophone with instant touch responsiveness, low-latency audio feedback, and high-contrast dark theme aesthetics.

---

## Visual Identity & Design System

Rivora adopts a refined brand identity derived from approved visual assets:

- **Primary Background**: `#0B1026` (Deep Navy)
- **Deep Accent Surface**: `#070914` / `#12172D`
- **Primary Color**: `#8B5CF6` (Rich Violet)
- **Primary Highlight**: `#A855F7` (Electric Purple)
- **Secondary Accent**: `#C4B5FD` (Soft Lavender)
- **Contrast Text**: `#F8FAFC` (Bright White) / `#A5B4FC` (Cool Slate)

---

## Features

- **In-App Hero Splash Animation**: Native launch screen transition smoothly fading into the Rivora symbol with a radial violet shimmer.
- **Landscape-Only Orientation**: Locked to `landscapeLeft` and `landscapeRight` with a responsive portrait fallback screen guarding accidental rotations.
- **Multi-Touch Interactive Drum Kit**: 10-piece acoustic set including Kick, Snare, Toms, Hi-Hat, Cymbals, and Pedals.
- **Acoustic Xylophone**: Color-tuned 7-note diatonic scale (C to B) with sound wave feedback.
- **Centralized Settings**: Master audio toggle, haptic feedback options, and app metadata.

---

## Build & Release Verification

Run the following commands to validate the project build:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter build apk --release
```
