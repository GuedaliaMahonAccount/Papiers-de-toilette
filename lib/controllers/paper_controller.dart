import 'package:flutter/material.dart';
import '../models/paper_models.dart';
import 'dart:math' as math;

class PaperController extends ChangeNotifier {
  static const double segmentHeight = 400.0;
  static const int totalSegments = 10000; // Large number for infinite feel

  // Initialize state with the first segment (index 0) already dirty.
  PaperState _state = PaperState(segments: {0: PaperSegment(index: 0, dirtiness: 1.0)});
  double _lastScrollOffset = 0.0;
  int _totalTouches = 0; // Track total touches/interactions

  PaperState get state => _state;
  int get totalTouches => _totalTouches;

  /// Moyenne du niveau de saleté (0..1)
  double get averageDirtiness {
    if (_state.segments.isEmpty) return 0.0;
    final total = _state.segments.values
        .map((s) => s.dirtiness)
        .fold<double>(0.0, (a, b) => a + b);
    return total / _state.segments.length;
  }

  /// Update scroll position (avec dimension réelle du viewport)
  void onScroll(double scrollOffset, double viewportExtent) {
    final double delta = scrollOffset - _lastScrollOffset;
    final ScrollDirection newDirection = _getDirection(delta);

    if (delta.abs() > 5.0) {
      _totalTouches++;
    }

    final int newTopIndex =
        (scrollOffset / segmentHeight).floor().clamp(0, totalSegments - 1);
    final int newBottomIndex = ((scrollOffset + viewportExtent) / segmentHeight)
        .ceil()
        .clamp(0, totalSegments - 1);

    // Calcul du segment au milieu de l'écran pour déclencher la saleté plus tôt
    final double middleScreenOffset = scrollOffset + (viewportExtent / 2);
    final int middleScreenIndex = (middleScreenOffset / segmentHeight).floor().clamp(0, totalSegments - 1);

    // Mise à jour de l'index le plus bas visité
    if (newDirection == ScrollDirection.down) {
      if (newBottomIndex > _state.highestVisitedIndex) {
        _state = _state.copyWith(highestVisitedIndex: newBottomIndex);
      }
      
      // Commence à salir dès qu'on atteint le milieu de l'écran avec un segment déjà visité
      if (middleScreenIndex <= _state.highestVisitedIndex && middleScreenIndex > 0) {
        _increaseDirtiness(middleScreenIndex);
      }
    }

    // En remontant, on "salit" en continu les segments déjà visités (pas d'empreintes, juste la texture)
    if (newDirection == ScrollDirection.up) {
      _dirtyVisibleRevisitedRange(newTopIndex, newBottomIndex);
      
      // Salit aussi le segment au milieu de l'écran quand on remonte
      if (middleScreenIndex <= _state.highestVisitedIndex && middleScreenIndex >= 0) {
        _increaseDirtiness(middleScreenIndex);
      }

      // Si on saute plusieurs segments d'un coup (fling), les couvrir aussi
      final int prevTop = _state.currentTopIndex;
      if (newTopIndex < prevTop) {
        _dirtyVisibleRevisitedRange(newTopIndex, prevTop);
      }
    }

    _state = _state.copyWith(
      currentTopIndex: newTopIndex,
      lastDirection: newDirection,
    );

    _lastScrollOffset = scrollOffset;
    notifyListeners();
  }

  /// Get or create segment
  PaperSegment getOrCreateSegment(int index) {
    if (!_state.segments.containsKey(index)) {
      _state.segments[index] = PaperSegment(index: index);
    }
    return _state.segments[index]!;
  }

  /// Salit chaque segment de [start, end] si déjà visité
  void _dirtyVisibleRevisitedRange(int startIndex, int endIndex) {
    if (startIndex > _state.highestVisitedIndex) return;
    final int lastEligible = math.min(endIndex, _state.highestVisitedIndex);

    for (int idx = startIndex; idx <= lastEligible; idx++) {
      _increaseDirtiness(idx);
    }
  }

  /// Augmente seulement la "dirtiness" (plus de marques)
  void _increaseDirtiness(int segmentIndex) {
    final segment = getOrCreateSegment(segmentIndex);
    if (segment.dirtiness >= 1.0) return;

    // Transition plus rapide : dès qu'on touche un segment déjà visité, il devient sale
    final double step = 0.8; // Basculement instantané vers sale
    final double newDirtiness = (segment.dirtiness + step).clamp(0.0, 1.0);

    _state.segments[segmentIndex] = segment.copyWith(
      // marks inchangé (non utilisé)
      dirtiness: newDirtiness,
    );
  }

  void handleCut() {
  // New roll: keep the first segment already dirty by default
  _state = PaperState(segments: {0: PaperSegment(index: 0, dirtiness: 1.0)});
    _lastScrollOffset = 0.0;
    _totalTouches = 0;
    notifyListeners();
  }

  ScrollDirection _getDirection(double delta) {
    const double threshold = 1.5;
    if (delta > threshold) return ScrollDirection.down;
    if (delta < -threshold) return ScrollDirection.up;
    return ScrollDirection.idle;
  }

  void resetScrollPosition() {
    _lastScrollOffset = 0.0;
  }
}
