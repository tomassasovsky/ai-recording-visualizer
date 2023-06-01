// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Box _$BoxFromJson(Map<String, dynamic> json) => Box(
      json['imageWidth'] as int,
      json['imageHeight'] as int,
      (json['x0'] as num).toDouble(),
      (json['y0'] as num).toDouble(),
      (json['x1'] as num).toDouble(),
      (json['y1'] as num).toDouble(),
      json['labelId'] as int,
      (json['score'] as num).toDouble(),
      json['detectedAt'] as int,
    );
