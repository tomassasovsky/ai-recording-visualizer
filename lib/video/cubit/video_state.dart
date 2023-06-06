part of 'video_cubit.dart';

class VideoState extends Equatable {
  const VideoState({
    this.ballDetections = const [],
    this.hoopDetections = const [],
    this.timestamp = 0,
    this.turnAction,
    this.zoomAdjustment,
  });

  final List<Box> ballDetections;
  final List<Box> hoopDetections;
  final int timestamp;
  final TurnAction? turnAction;
  final double? zoomAdjustment;

  VideoState copyWith({
    List<Box>? ballDetections,
    List<Box>? hoopDetections,
    List<TurnAction>? turnActions,
    List<double>? zoomAdjustments,
    int? timestamp,
    TurnAction? turnAction,
    double? zoomAdjustment,
  }) {
    return VideoState(
      ballDetections: ballDetections ?? this.ballDetections,
      hoopDetections: hoopDetections ?? this.hoopDetections,
      timestamp: timestamp ?? this.timestamp,
      turnAction: turnAction ?? this.turnAction,
      zoomAdjustment: zoomAdjustment ?? this.zoomAdjustment,
    );
  }

  @override
  List<Object?> get props => [
        ballDetections,
        hoopDetections,
        timestamp,
        turnAction,
        zoomAdjustment,
      ];
}
