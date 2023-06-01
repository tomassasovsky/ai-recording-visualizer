import 'dart:convert';

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
  });

  factory MetadataLog.fromJson(Map<String, dynamic> json) =>
      _$MetadataLogFromJson(json);

  final int inputSize;
  final SensorMetadata sensorMetadata;
  final int? startFrame;
  final int? endFrame;
  final List<Box> ballDetections;
  final List<Box> hoopDetections;
  final List<TurnAction> turnActions;
  final List<ZoomAdjustment> zoomAdjustments;
  final List<String> logs;
}
