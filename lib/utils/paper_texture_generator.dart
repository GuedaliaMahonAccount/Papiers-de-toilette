import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Creates a simple paper texture programmatically
class PaperTextureGenerator {
  static Future<ui.Image> generateTexture({
    int width = 100,
    int height = 100,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
    final paint = Paint();
    final random = math.Random(42); // Fixed seed for consistency
    
    // Base color
    paint.color = const Color(0xFFFAF8F5);
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), paint);
    
    // Add fiber-like texture
    paint.strokeWidth = 0.5;
    for (int i = 0; i < 100; i++) {
      paint.color = Color.fromRGBO(
        235 + random.nextInt(10),
        230 + random.nextInt(10),
        220 + random.nextInt(10),
        0.3,
      );
      
      final start = Offset(
        random.nextDouble() * width,
        random.nextDouble() * height,
      );
      final end = Offset(
        start.dx + (random.nextDouble() - 0.5) * 10,
        start.dy + (random.nextDouble() - 0.5) * 10,
      );
      
      canvas.drawLine(start, end, paint);
    }
    
    final picture = recorder.endRecording();
    return await picture.toImage(width, height);
  }
}
