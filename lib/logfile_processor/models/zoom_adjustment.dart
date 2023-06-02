import 'package:json_annotation/json_annotation.dart';

part 'zoom_adjustment.g.dart';

@JsonSerializable(createToJson: false)
class ZoomAdjustment {
  ZoomAdjustment(
    this.zoomLevel,
    this.timestamp,
  );

  factory ZoomAdjustment.fromJson(Map<String, dynamic> json) =>
      _$ZoomAdjustmentFromJson(json);

  final double zoomLevel;
  final int timestamp;

  ZoomAdjustment copyWith({
    double? zoomLevel,
    int? timestamp,
  }) {
    return ZoomAdjustment(
      zoomLevel ?? this.zoomLevel,
      timestamp ?? this.timestamp,
    );
  }
}
