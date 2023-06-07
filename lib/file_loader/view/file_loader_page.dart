import 'package:ai_recording_visualizer/file_loader/file_loader.dart';
import 'package:ai_recording_visualizer/l10n/l10n.dart';
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
  final PageController pageController = PageController();

  VideoFileLoaderCubit get videoFileLoaderCubit =>
      context.read<VideoFileLoaderCubit>();
  LogFileLoaderCubit get logFileLoaderCubit =>
      context.read<LogFileLoaderCubit>();

  @override
  void dispose() {
    logFileLoaderCubit.close();
    videoFileLoaderCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VideoFileLoaderCubit, FileLoaderState>(
      listener: (context, state) {
        if (state is FileLoaderLoaded && pageController.page == 0) {
          pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          logFileLoaderCubit.getLogRemotely(state.uuid()!);
        }
      },
      child: Scaffold(
        body: PageView.builder(
          controller: pageController,
          itemCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return index == 0
                ? const FilePickerButton<VideoFileLoaderCubit>()
                : Stack(
                    children: [
                      const FilePickerButton<LogFileLoaderCubit>(),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: FloatingActionButton(
                          onPressed: () => pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          heroTag: 'back',
                          backgroundColor: Colors.black87,
                          child: const Icon(Icons.arrow_back),
                        ),
                      )
                    ],
                  );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: nextButton,
          backgroundColor: Colors.black87,
          heroTag: 'play',
          child: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }

  void nextButton() {
    final logFileState = logFileLoaderCubit.state;
    final videoFileState = videoFileLoaderCubit.state;
    final currentPage = pageController.page?.toInt() ?? 0;
    if (currentPage == 0 && videoFileState is FileLoaderLoaded) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    } else if (currentPage == 1 &&
        logFileState is FileLoaderLoaded &&
        videoFileState is FileLoaderLoaded) {
      final videoFile = videoFileState.file;
      final metadata = logFileState.parseMetadataSync();
      Navigator.of(context).pushNamed(
        '/video-player',
        arguments: {
          'videoPath': videoFile.path,
          'metadataLog': metadata,
        },
      );
      return;
    }

    noFileLoadedBanner();
  }

  void noFileLoadedBanner() {
    final l10n = context.l10n;

    Future<void> hideBanner() async {
      await Future<void>.delayed(const Duration(seconds: 2));

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner(
          reason: MaterialBannerClosedReason.dismiss,
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text(l10n.fileNotSetPleaseSelect),
          actions: [
            TextButton(
              onPressed: hideBanner,
              child: Text(l10n.close),
            ),
          ],
          onVisible: hideBanner,
          animation: AnimationController(
            vsync: ScaffoldMessenger.of(context),
            duration: const Duration(seconds: 2),
          ),
        ),
      );
    });
  }
}
