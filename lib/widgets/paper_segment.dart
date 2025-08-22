import 'package:flutter/material.dart';
import '../models/paper_models.dart';
import '../painters/marks_painter.dart';
import 'paper_background.dart';

class PaperSegmentWidget extends StatelessWidget {
  final PaperSegment segment;
  final double height;
  final bool showPerforation;

  const PaperSegmentWidget({
    super.key,
    required this.segment,
    this.height = 400.0,
    this.showPerforation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Color(0xFFE8E6E3), width: 1),
          right: BorderSide(color: Color(0xFFE8E6E3), width: 1),
        ),
      ),
      child: Stack(
        children: [
          // Modern paper background with transition
          PaperBackgroundWidget(
            dirtiness: segment.dirtiness,
            width: double.infinity,
            height: height,
            animationSeed: segment.index,
          ),
          
          // Ink marks with enhanced appearance
          CustomPaint(
            size: Size(double.infinity, height),
            painter: MarksPainter(
              marks: segment.marks,
              segmentHeight: height,
              dirtiness: segment.dirtiness,
            ),
          ),
          
          // Perforation line at bottom
          if (showPerforation)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildPerforationLine(),
            ),
            
          // Modern shine effect for clean paper
          if (segment.dirtiness < 0.5)
            _buildShineEffect(),
        ],
      ),
    );
  }

  Widget _buildShineEffect() {
    return Positioned.fill(
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 600),
        opacity: (1.0 - segment.dirtiness) * 0.3,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0, -1.0),
              end: Alignment(1.0, 1.0),
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.0),
              ],
              stops: [0.0, 0.1, 0.2],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerforationLine() {
    return Container(
      height: 2,
      child: CustomPaint(
        size: const Size(double.infinity, 2),
        painter: PerforationPainter(),
      ),
    );
  }
}

/// Painter for the perforation line at the bottom of each segment
class PerforationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    const double dotSize = 2.0;
    const double spacing = 6.0;
    
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawCircle(
        Offset(x + dotSize / 2, size.height / 2),
        dotSize / 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
