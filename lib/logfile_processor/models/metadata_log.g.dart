// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetadataLog _$MetadataLogFromJson(Map<String, dynamic> json) => MetadataLog(
      inputSize: json['inputSize'] as int,
      sensorMetadata: json['sensorMetadata'] == null
          ? null
          : SensorMetadata.fromJson(
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
      turnActions: (json['turnActions'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            int.parse(k), TurnAction.fromJson(e as Map<String, dynamic>)),
      ),
      zoomAdjustments: (json['zoomAdjustments'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
      ),
      logs: (json['logs'] as List<dynamic>).map((e) => e as String).toList(),
    );
