import 'package:ai_recording_visualizer/file_loader/file_loader.dart';
import 'package:ai_recording_visualizer/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class FilePickerButton<T extends FileLoaderCubit> extends StatelessWidget {
  const FilePickerButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final fileLoaderState = context.watch<T>().state;
    final fileType = context.select((T cubit) => cubit.fileLoaderType.name);
    final isLoading =
        context.select((T cubit) => cubit.state) is FileLoaderLoading;
    final isLoaded = fileLoaderState is FileLoaderLoaded;
    final isRemoteError = fileLoaderState is FileLoaderErrorRemoteNotFound;

    if (isRemoteError) {
      showRemoteErrorDialog(context);
    }

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: MaterialButton(
              color: isLoaded ? Colors.purple[50] : Colors.white,
              elevation: 0,
              onPressed: () => context.read<T>().loadFile(),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/$fileType.svg',
                      width: 64,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    if (isLoaded) ...[
                      Text(fileLoaderState.file.name),
                      Text(
                        sizeInHumanReadableForm(fileLoaderState.file.size),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ] else
                      Text(l10n.selectFile(fileType)),
                    if (isLoading) ...[
                      const SizedBox(height: 32),
                      const CircularProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isLoading) ...[
          const AbsorbPointer(),
          const ColoredBox(
            color: Colors.black38,
            child: SizedBox.expand(),
          ),
        ],
      ],
    );
  }

  void showRemoteErrorDialog(BuildContext context) {
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
          content: Text(l10n.logFileNotFoundRemotely),
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

  String sizeInHumanReadableForm(int sizeInBytes) {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(2)} KB';
    } else if (sizeInBytes < 1024 * 1024 * 1024) {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(sizeInBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }
}
