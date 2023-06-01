import 'package:ai_recording_visualizer/logfile_processor/logfile_processor.dart';
import 'package:bloc/bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:meta/meta.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit(
    this.videoPath,
    this.metadataLog,
  ) : super(VideoInitial());

  Future<void> init() async {
    await player.open(Media(videoPath));
  }

  @override
  Future<void> close() async {
    await player.dispose();
    return super.close();
  }

  final Player player = Player();
  late final controller = VideoController(player);
  final String videoPath;
  final MetadataLog metadataLog;
}
