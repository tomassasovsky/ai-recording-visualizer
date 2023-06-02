import 'dart:developer';

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
    log('painting bounding boxes');
    for (final detection in detections.entries) {
      final color = detection.key;
      final boxes = detection.value;

      for (final box in boxes) {
        final rect = box.translatedRect(size.width, size.height);

        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

        canvas.drawRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(BoundingBoxesPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(BoundingBoxesPainter oldDelegate) => true;
}
