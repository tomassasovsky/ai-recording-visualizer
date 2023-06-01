import 'package:ai_recording_visualizer/file_loader/file_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileLoaderPage extends StatelessWidget {
  const FileLoaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => VideoFileLoaderCubit(),
        ),
        BlocProvider(
          create: (_) => LogFileLoaderCubit(),
        ),
      ],
      child: const FileLoaderView(),
    );
  }
}

class FileLoaderView extends StatefulWidget {
  const FileLoaderView({super.key});

  @override
  State<FileLoaderView> createState() => _FileLoaderViewState();
}

class _FileLoaderViewState extends State<FileLoaderView> {
  final ValueNotifier<bool> filesLoaded = ValueNotifier(false);

  VideoFileLoaderCubit get videoFileLoaderCubit =>
      context.read<VideoFileLoaderCubit>();
  LogFileLoaderCubit get logFileLoaderCubit =>
      context.read<LogFileLoaderCubit>();

  @override
  void initState() {
    super.initState();
    videoFileLoaderCubit.stream.listen(
      (event) => filesLoaded.value = event is FileLoaderLoaded &&
          logFileLoaderCubit.state is FileLoaderLoaded,
    );
    logFileLoaderCubit.stream.listen(
      (event) => filesLoaded.value = event is FileLoaderLoaded &&
          videoFileLoaderCubit.state is FileLoaderLoaded,
    );
  }

  @override
  void dispose() {
    filesLoaded.dispose();
    logFileLoaderCubit.close();
    videoFileLoaderCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilePickerButton<VideoFileLoaderCubit>(),
            SizedBox(width: 8),
            FilePickerButton<LogFileLoaderCubit>(),
          ],
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: filesLoaded,
        builder: (context, value, child) {
          if (value) {
            return FloatingActionButton(
              onPressed: () {
                final logFileState = logFileLoaderCubit.state;
                final videoFileState = videoFileLoaderCubit.state;
                if (logFileState is! FileLoaderLoaded ||
                    videoFileState is! FileLoaderLoaded) {
                  return;
                }

                final videoFile = videoFileState.file;
                final metadata = logFileState.parseMetadataSync();

                Navigator.of(context).pushNamed(
                  '/video-player',
                  arguments: {
                    'videoPath': videoFile.path,
                    'metadataLog': metadata,
                  },
                );
              },
              child: const Icon(Icons.arrow_forward),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
