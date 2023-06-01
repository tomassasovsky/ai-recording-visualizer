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

class FileLoaderView extends StatelessWidget {
  const FileLoaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
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
    );
  }
}
