import 'package:json_annotation/json_annotation.dart';

part 'sensor_metadata.g.dart';

@JsonSerializable(createToJson: false)
class SensorMetadata {
  SensorMetadata(
    this.horizontalFOV,
    this.verticalFOV,
    this.sensorWidth,
    this.sensorHeight,
    this.focalLength,
  );

  factory SensorMetadata.fromJson(Map<String, dynamic> json) =>
      _$SensorMetadataFromJson(json);

  final double horizontalFOV;
  final double verticalFOV;
  final double sensorWidth;
  final double sensorHeight;
  final double focalLength;
}
