import 'dart:math';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'box.g.dart';

@JsonSerializable(createToJson: false)
class Box {
  Box(
    this.imageWidth,
    this.imageHeight,
    this.x0,
    this.y0,
    this.x1,
    this.y1,
    this.labelId,
    this.score,
    this.timestamp,
  );

  factory Box.fromJson(Map<String, dynamic> json) => _$BoxFromJson(json);

  final int imageWidth;
  final int imageHeight;
  final double x0;
  final double y0;
  final double x1;
  final double y1;
  final int labelId;
  final double score;
  final int timestamp;

  Rect get rect => Rect.fromLTRB(x0, y0, x1, y1);

  Rect translatedRect(double width, double height) {
    final scaleX = width / imageWidth;
    final scaleY = height / imageHeight;
    return Rect.fromLTRB(x0 * scaleX, y0 * scaleY, x1 * scaleX, y1 * scaleY);
  }

  double get centerX => (x0 + x1) / 2;

  double get centerY => (y0 + y1) / 2;

  Point<double> get center => Point(centerX, centerY);

  String get label => labels[labelId];

  static List<String> labels = ['basketball', 'hoop'];

  Color color() {
    final random = Random(labelId);
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  Box copyWith({
    int? imageWidth,
    int? imageHeight,
    double? x0,
    double? y0,
    double? x1,
    double? y1,
    int? labelId,
    double? score,
    int? timestamp,
  }) {
    return Box(
      imageWidth ?? this.imageWidth,
      imageHeight ?? this.imageHeight,
      x0 ?? this.x0,
      y0 ?? this.y0,
      x1 ?? this.x1,
      y1 ?? this.y1,
      labelId ?? this.labelId,
      score ?? this.score,
      timestamp ?? this.timestamp,
    );
  }
}
