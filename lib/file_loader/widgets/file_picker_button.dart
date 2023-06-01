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
    final fileLoaderState = context.select((T cubit) => cubit.state);
    final fileType = context.select((T cubit) => cubit.fileLoaderType.name);
    final isLoaded = fileLoaderState is FileLoaderLoaded;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
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
                      '${fileLoaderState.file.size ~/ 1024} KB',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ] else
                    Text(l10n.selectFile(fileType)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
