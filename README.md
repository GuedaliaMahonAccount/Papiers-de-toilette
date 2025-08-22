# Endless Paper Roll 🧻

A whimsical Flutter app that simulates an endless toilet paper roll that you can unroll, mark, and cut!

## Features

- **Infinite Scrolling**: Scroll down to unroll fresh paper segments, scroll up to revisit previous sections
- **Playful Ink Marks**: When you reverse direction (scroll up over previously visited areas), subtle gray ink smudges appear as a visual gag
- **Cut Animation**: Tap the scissors button to cut the current segment with a satisfying tear animation and reset to fresh paper
- **Paper-like Design**: Off-white background with subtle gradients and perforation lines for authenticity
- **Smooth Animations**: Fluid scrolling, mark appearances, and cutting animations
- **Haptic Feedback**: Light vibrations when cutting (on supported devices)

## Core Interactions

1. **Scroll Down**: Reveals new, clean paper segments (infinite feel)
2. **Scroll Up**: Revisit previously seen segments where ink marks may appear
3. **Cut Action**: Floating scissors button cuts and resets the roll

## Technical Implementation

- **Framework**: Flutter (Dart only, no backend required)
- **Architecture**: Clean separation with models, controllers, widgets, and painters
- **State Management**: Simple local state using ChangeNotifier
- **Custom Painting**: Hand-drawn ink marks using CustomPainter
- **Animations**: Smooth tear effects and mark fade-ins

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── paper_models.dart       # Data models for paper segments and state
├── controllers/
│   └── paper_controller.dart   # Business logic for scroll handling and marking
├── screens/
│   └── home_screen.dart        # Main screen with paper roll
├── widgets/
│   ├── paper_segment.dart      # Individual paper segment widget
│   └── cut_fab.dart            # Floating action button for cutting
└── painters/
    └── marks_painter.dart      # Custom painter for ink marks
```

## Key Classes

- `PaperSegment`: Represents a single segment of paper with its marks
- `PaperState`: Overall state including visited segments and scroll direction
- `PaperController`: Handles scroll detection, mark creation, and cutting logic
- `MarksPainter`: Custom painter for drawing organic-looking ink smudges

## Behavior Details

- **Mark Creation**: Appears when scrolling up over previously visited segments
- **Mark Density**: Maximum 12 marks per segment to prevent overcrowding
- **Direction Detection**: Tracks scroll delta to determine up/down movement
- **Segment Height**: Fixed 400px per segment for consistent experience
- **Performance**: Uses efficient ListView.builder for smooth scrolling

## Running the App

1. Ensure Flutter is installed and configured
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app

## Fun Details

- Subtle paper texture using gradients
- Perforation lines between segments
- Brown scissors icon for cutting
- Off-white paper color palette
- Organic, irregular ink mark shapes
- Smooth tear animation with opacity and scale effects

Enjoy unrolling your endless paper! 🎉