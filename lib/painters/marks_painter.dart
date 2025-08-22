import 'package:flutter/material.dart';

/// Custom painter to draw ink marks on paper segments
class MarksPainter extends CustomPainter {
  final List<Offset> marks;
  final double segmentHeight;
  final double dirtiness; // 0.0 = clean, 1.0 = dirty

  MarksPainter({
    required this.marks,
    required this.segmentHeight,
    this.dirtiness = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (marks.isEmpty) return;

    // Base mark color gets darker with dirtiness
    final baseOpacity = 0.3 + (dirtiness * 0.4);
    final markColor = Color.lerp(
      Colors.grey.withOpacity(baseOpacity),
      Colors.brown.withOpacity(baseOpacity * 1.2),
      dirtiness,
    )!;

    final Paint markPaint = Paint()
      ..color = markColor
      ..style = PaintingStyle.fill;

    final Paint shadowPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1 + dirtiness * 0.2)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < marks.length; i++) {
      final mark = marks[i];
      // Ensure mark is within bounds
      final adjustedOffset = Offset(
        mark.dx.clamp(10.0, size.width - 10.0),
        mark.dy.clamp(10.0, size.height - 10.0),
      );

      // Size varies with dirtiness and mark age
      final baseSize = 3.0 + (dirtiness * 2.0);
      final markSize = baseSize + (i % 3) * 0.5; // Slight variation

      // Draw shadow first
      canvas.drawCircle(
        adjustedOffset + const Offset(1, 1),
        markSize + 1.0,
        shadowPaint,
      );

      // Draw main mark
      canvas.drawCircle(
        adjustedOffset,
        markSize,
        markPaint,
      );

      // Add some irregular shape for more organic look - gets more prominent with dirtiness
      final ovalSize = 2.0 + dirtiness * 3.0;
      canvas.drawOval(
        Rect.fromCenter(
          center: adjustedOffset + Offset(-1.0 - dirtiness, 0.5 + dirtiness),
          width: ovalSize,
          height: ovalSize * 0.6,
        ),
        markPaint,
      );
    }
  }

  @override
  bool shouldRepaint(MarksPainter oldDelegate) {
    return marks != oldDelegate.marks || dirtiness != oldDelegate.dirtiness;
  }
}
