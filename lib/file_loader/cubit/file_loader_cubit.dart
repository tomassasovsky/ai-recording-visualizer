import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

part 'file_loader_state.dart';

enum FileLoaderType {
  json,
  video;

  String get extension {
    switch (this) {
      case FileLoaderType.json:
        return 'json';
      case FileLoaderType.video:
        return 'mp4';
    }
  }
}

class LogFileLoaderCubit extends FileLoaderCubit {
  LogFileLoaderCubit() : super(FileLoaderType.json);
}

class VideoFileLoaderCubit extends FileLoaderCubit {
  VideoFileLoaderCubit() : super(FileLoaderType.video);
}

class FileLoaderCubit extends Cubit<FileLoaderState> {
  FileLoaderCubit(this.fileLoaderType) : super(const FileLoaderInitial());

  final FileLoaderType fileLoaderType;

  Future<void> loadFile() async {
    _safeEmit(const FileLoaderLoading());

    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [fileLoaderType.extension],
    );

    if (pickedFile == null) {
      _safeEmit(const FileLoaderError());
      return;
    }

    final file = pickedFile.files.single;
    _safeEmit(FileLoaderLoaded(file));
  }

  void _safeEmit(FileLoaderState state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
