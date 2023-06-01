import 'package:ai_recording_visualizer/logfile_processor/logfile_processor.dart';
import 'package:ai_recording_visualizer/video/video.dart';
import 'package:ai_recording_visualizer/video/widgets/video_controls.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = (ModalRoute.of(context)?.settings.arguments as Map?)
        ?.cast<String, dynamic>();

    if (arg == null) {
      return const Scaffold(
        body: Center(
          child: Text('No video path provided'),
        ),
      );
    }

    final videoPath = arg['videoPath'] as String;
    final metadataLog = arg['metadataLog'] as MetadataLog;

    return BlocProvider(
      create: (_) => VideoCubit(
        videoPath,
        metadataLog,
      ),
      child: const VideoView(),
    );
  }
}

class VideoView extends StatefulWidget {
  const VideoView({super.key});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoCubit get cubit => context.read<VideoCubit>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => cubit.init());
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Control(
        player: cubit.player,
        child: Video(controller: cubit.controller),
      ),
    );
  }
}
