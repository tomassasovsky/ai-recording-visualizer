import 'package:ai_recording_visualizer/logfile_processor/logfile_processor.dart';
import 'package:ai_recording_visualizer/video/video.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit(
    this.videoPath,
    this.metadataLog,
  ) : super(const VideoState());

  late List<int> totalTimeStampsList;

  /// Loads the video into the player and initializes the metadata log when
  /// the video duration is known. Also registers listeners for the video
  /// position to update the state with the current detections; see also:
  ///
  /// _onPositionChanged
  ///
  Future<void> init() async {
    player.streams.duration.listen(_onDurationChanged);
    player.streams.position.listen(_onPositionChanged);

    await player.open(Media(videoPath), play: false);
  }

  void _onDurationChanged(Duration duration) {
    videoDuration = duration;
  }

  Future<void> _onPositionChanged(Duration position) async {
    // Wait for the video duration to be known before normalizing the
    // metadata log.
    if (videoDuration == null) {
      return;
    }

    if (normalizedMetadataLog == null) {
      _normalizeMetadataLog();
    }

    if (!player.state.playing) {
      await player.play();
    }

    final nearestTimeStamp = totalTimeStampsList.nearestIndex(
      target: position.inMilliseconds,
      threshold: 150,
    );

    final ballDetections =
        normalizedMetadataLog?.ballDetections[nearestTimeStamp] ?? [];
    final hoopDetections =
        normalizedMetadataLog?.ballDetections[nearestTimeStamp] ?? [];

    emit(
      VideoState(
        ballDetections: ballDetections,
        hoopDetections: hoopDetections,
      ),
    );
  }

  void _normalizeMetadataLog() {
    normalizedMetadataLog =
        metadataLog.normalizeTimestamps(videoDuration: videoDuration!);

    final ballDetectionsTimeStamps =
        normalizedMetadataLog?.ballDetections.keys.toList();
    final hoopDetectionsTimeStamps =
        normalizedMetadataLog?.hoopDetections.keys.toList();
    totalTimeStampsList = <int>{
      ...?ballDetectionsTimeStamps,
      ...?hoopDetectionsTimeStamps,
    }.toList()
      ..sort();
  }

  final String videoPath;
  final MetadataLog metadataLog;

  late final controller = VideoController(player);
  final Player player = Player();
  MetadataLog? normalizedMetadataLog;
  Duration? videoDuration;
}
