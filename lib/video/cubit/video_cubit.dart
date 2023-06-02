// import 'dart:developer';

import 'dart:developer';
import 'dart:math' as math;

import 'package:ai_recording_visualizer/logfile_processor/logfile_processor.dart';
import 'package:ai_recording_visualizer/video/video.dart';
// import 'package:ai_recording_visualizer/video/video.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit(
    this.videoPath,
    MetadataLog metadataLog,
  ) : super(const VideoState()) {
    this.metadataLog = metadataLog.normalizeTimestamps();
  }

  final futures = <CancelableFuture<void>>[];

  Future<void> init() async {
    final ballDetectionsTimeStamps = metadataLog.ballDetections.keys.toList();
    final hoopDetectionsTimeStamps = metadataLog.hoopDetections.keys.toList();
    final totalTimeStampsList = <int>{
      ...ballDetectionsTimeStamps,
      ...hoopDetectionsTimeStamps,
    }.toList()
      ..sort();
    // player.streams.playing.listen((event) {
    //   if (!event) {
    //     for (final future in futures) {
    //       future.cancel();
    //     }
    //     return;
    //   }

    //   final currentPosition = player.state.position;

    //   // calculate how many miliseconds to wait before showing each list of
    //   // detections
    //   for (final entry in metadataLog.ballDetections.entries) {
    //     final frame = entry.key;

    //     final delayInMillis = frame - currentPosition.inMilliseconds;
    //     if (delayInMillis <= 0) {
    //       continue;
    //     }
    //     log('delay: $delayInMillis');
    //     final delay = Duration(milliseconds: math.max(delayInMillis - 2000, 0));

    //     final future = CancelableFuture(
    //       future: Future<void>.delayed(delay),
    //       onComplete: () {
    //         emit(
    //           VideoState(
    //             ballDetections: entry.value,
    //             hoopDetections: metadataLog.hoopDetections[frame] ?? [],
    //             turnActions: metadataLog.turnActions
    //                 .where((element) => element.timestamp == frame)
    //                 .toList(),
    //             zoomAdjustments: metadataLog.zoomAdjustments
    //                 .where((element) => element.timestamp == frame)
    //                 .toList(),
    //           ),
    //         );
    //       },
    //     );

    //     futures.add(future);
    //   }
    // });

    player.streams.position.listen((event) {
      final nearestTimeStamp = totalTimeStampsList.nearestIndex(
        target: event.inMilliseconds,
        threshold: 1000,
      );

      final ballDetections = metadataLog.ballDetections[nearestTimeStamp] ?? [];
      final hoopDetections = metadataLog.ballDetections[nearestTimeStamp] ?? [];

      if (nearestTimeStamp != null) {
        log('nearestTimeStamp: ${event.inMilliseconds} -> $nearestTimeStamp');
      }

      emit(
        VideoState(
          ballDetections: ballDetections,
          hoopDetections: hoopDetections,
        ),
      );
    });

    await player.open(Media(videoPath));
  }

  final Player player = Player();
  late final controller = VideoController(player);
  final String videoPath;
  late final MetadataLog metadataLog;
}

class CancelableFuture<T> {
  CancelableFuture({
    required Future<T> future,
    required void Function() onComplete,
  }) {
    future.whenComplete(() {
      if (!_cancelled) onComplete();
    });
  }

  bool _cancelled = false;
  void cancel() {
    _cancelled = true;
  }
}
