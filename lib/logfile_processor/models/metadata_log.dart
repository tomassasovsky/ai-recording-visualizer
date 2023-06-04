import 'dart:convert';
import 'dart:math';

import 'package:ai_recording_visualizer/logfile_processor/logfile_processor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'metadata_log.g.dart';

MetadataLog parseMetadataLog(String json) {
  final parsed = (jsonDecode(json) as Map).cast<String, dynamic>();
  return MetadataLog.fromJson(parsed);
}

@JsonSerializable(createToJson: false)
class MetadataLog {
  const MetadataLog({
    required this.inputSize,
    required this.sensorMetadata,
    required this.startFrame,
    required this.endFrame,
    required this.ballDetections,
    required this.hoopDetections,
    required this.turnActions,
    required this.zoomAdjustments,
    required this.logs,
    this.normalizationMethod,
    this.startFrameCorrection,
  });

  factory MetadataLog.fromJson(Map<String, dynamic> json) =>
      _$MetadataLogFromJson(json);

  final int inputSize;
  final SensorMetadata sensorMetadata;
  final int? startFrame;
  final int? endFrame;
  final Map<int, List<Box>> ballDetections;
  final Map<int, List<Box>> hoopDetections;
  final Map<int, TurnAction> turnActions;
  final Map<int, double> zoomAdjustments;
  final List<String> logs;
  @JsonKey(includeFromJson: false)
  final NormalizationMethod? normalizationMethod;
  @JsonKey(includeFromJson: false)
  final int? startFrameCorrection;

  // Converts all timestamps relative to the start of the video (0s)
  MetadataLog normalizeTimestamps({
    required Duration videoDuration,
  }) {
    NormalizationMethod normalizationMethod;
    int? startFrameCorrection;

    // startFrame is unreliable, so we need to use the endFrame and
    // video duration to calculate it
    int startFrame;
    if (endFrame != null) {
      startFrameCorrection =
          endFrame! - this.startFrame! - videoDuration.inMilliseconds;
      startFrame = this.startFrame! + startFrameCorrection;
      normalizationMethod = NormalizationMethod.endTimestampAndDuration;
    } else {
      startFrame = this.startFrame ?? 0;
      normalizationMethod = NormalizationMethod.startTimestamp;
    }

    final ballDetections = <int, List<Box>>{};
    for (final entry in this.ballDetections.entries) {
      final detections = <Box>[];
      for (final detection in entry.value) {
        detections.add(
          detection.copyWith(
            timestamp: detection.timestamp - startFrame,
          ),
        );
      }

      ballDetections[entry.key - startFrame] = detections;
    }

    final hoopDetections = <int, List<Box>>{};
    for (final entry in this.hoopDetections.entries) {
      final detections = <Box>[];
      for (final detection in entry.value) {
        detections.add(
          detection.copyWith(
            timestamp: detection.timestamp - startFrame,
          ),
        );
      }

      hoopDetections[entry.key - startFrame] = detections;
    }

    final turnActions = <int, TurnAction>{};
    for (final entry in this.turnActions.entries) {
      turnActions[entry.key - startFrame] = entry.value.copyWith(
        timestamp: entry.value.timestamp - startFrame,
      );
    }

    final zoomAdjustments = <int, double>{};
    for (final entry in this.zoomAdjustments.entries) {
      zoomAdjustments[entry.key - startFrame] = entry.value;
    }

    return MetadataLog(
      inputSize: inputSize,
      sensorMetadata: sensorMetadata,
      startFrame: 0,
      endFrame: max(0, (endFrame ?? 0) - startFrame),
      ballDetections: ballDetections,
      hoopDetections: hoopDetections,
      turnActions: turnActions,
      zoomAdjustments: zoomAdjustments,
      logs: logs,
      normalizationMethod: normalizationMethod,
      startFrameCorrection: startFrameCorrection,
    );
  }
}

enum NormalizationMethod {
  startTimestamp,
  endTimestampAndDuration,
}
