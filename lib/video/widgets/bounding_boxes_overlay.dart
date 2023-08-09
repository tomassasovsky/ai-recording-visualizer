import 'package:ai_recording_visualizer/logfile_processor/logfile_processor.dart';
import 'package:flutter/material.dart';

class BoundingBoxesOverlay extends StatelessWidget {
  const BoundingBoxesOverlay(
    this.detections, {
    super.key,
  });

  final Map<Color, List<Box>> detections;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BoundingBoxesPainter(detections),
    );
  }
}

class BoundingBoxesPainter extends CustomPainter {
  BoundingBoxesPainter(this.detections);

  final Map<Color, List<Box>> detections;

  @override
  void paint(Canvas canvas, Size size) {
    for (final detection in detections.entries) {
      final color = detection.key;
      final boxes = detection.value;

      for (final box in boxes) {
        final rect = box.translatedRect(size.width, size.height);

        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawRect(rect, paint);
        final textPainter = TextPainter(
          text: TextSpan(
            text: box.label,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: '\n${(box.score * 100).toInt()}%',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter
          ..layout()
          ..paint(
            canvas,
            Offset(rect.left, rect.top - textPainter.height - 4),
          );
      }
    }
  }

  @override
  bool shouldRepaint(BoundingBoxesPainter oldDelegate) =>
      oldDelegate.detections != detections;
}
