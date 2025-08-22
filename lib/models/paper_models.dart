import 'package:flutter/material.dart';

/// Represents a single segment of the paper roll
class PaperSegment {
  final int index;
  final List<Offset> marks;
  final double dirtiness; // 0.0 = clean, 1.0 = dirty

  PaperSegment({
    required this.index,
    this.marks = const [],
    this.dirtiness = 0.0,
  });

  PaperSegment copyWith({
    int? index,
    List<Offset>? marks,
    double? dirtiness,
  }) {
    return PaperSegment(
      index: index ?? this.index,
      marks: marks ?? this.marks,
      dirtiness: dirtiness ?? this.dirtiness,
    );
  }
}

/// Represents the overall state of the paper roll
class PaperState {
  int highestVisitedIndex;
  int currentTopIndex;
  final Map<int, PaperSegment> segments;
  ScrollDirection lastDirection;

  PaperState({
    this.highestVisitedIndex = 0,
    this.currentTopIndex = 0,
    Map<int, PaperSegment>? segments,
    this.lastDirection = ScrollDirection.idle,
  }) : segments = segments ?? {};

  PaperState copyWith({
    int? highestVisitedIndex,
    int? currentTopIndex,
    Map<int, PaperSegment>? segments,
    ScrollDirection? lastDirection,
  }) {
    return PaperState(
      highestVisitedIndex: highestVisitedIndex ?? this.highestVisitedIndex,
      currentTopIndex: currentTopIndex ?? this.currentTopIndex,
      segments: segments ?? Map<int, PaperSegment>.from(this.segments),
      lastDirection: lastDirection ?? this.lastDirection,
    );
  }
}

enum ScrollDirection { up, down, idle }
