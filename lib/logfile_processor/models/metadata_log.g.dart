// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetadataLog _$MetadataLogFromJson(Map<String, dynamic> json) => MetadataLog(
      inputSize: json['inputSize'] as int,
      sensorMetadata: SensorMetadata.fromJson(
          json['sensorMetadata'] as Map<String, dynamic>),
      startFrame: json['startFrame'] as int?,
      endFrame: json['endFrame'] as int?,
      ballDetections: (json['ballDetections'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k),
            (e as List<dynamic>)
                .map((e) => Box.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      hoopDetections: (json['hoopDetections'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k),
            (e as List<dynamic>)
                .map((e) => Box.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      turnActions: (json['turnActions'] as List<dynamic>)
          .map((e) => TurnAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      zoomAdjustments: (json['zoomAdjustments'] as List<dynamic>)
          .map((e) => ZoomAdjustment.fromJson(e as Map<String, dynamic>))
          .toList(),
      logs: (json['logs'] as List<dynamic>).map((e) => e as String).toList(),
    );
