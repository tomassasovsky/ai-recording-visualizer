part of 'video_cubit.dart';

class VideoState extends Equatable {
  const VideoState({
    this.ballDetections = const [],
    this.hoopDetections = const [],
    this.turnActions = const [],
    this.zoomAdjustments = const [],
    this.timestamp = 0,
  });

  final List<Box> ballDetections;
  final List<Box> hoopDetections;
  final List<TurnAction> turnActions;
  final List<ZoomAdjustment> zoomAdjustments;
  final int timestamp;

  VideoState copyWith({
    List<Box>? ballDetections,
    List<Box>? hoopDetections,
    List<TurnAction>? turnActions,
    List<ZoomAdjustment>? zoomAdjustments,
    int? timestamp,
  }) {
    return VideoState(
      ballDetections: ballDetections ?? this.ballDetections,
      hoopDetections: hoopDetections ?? this.hoopDetections,
      turnActions: turnActions ?? this.turnActions,
      zoomAdjustments: zoomAdjustments ?? this.zoomAdjustments,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [
        ballDetections,
        hoopDetections,
        turnActions,
        zoomAdjustments,
        timestamp,
      ];
}
