import 'dart:convert';

import 'package:ai_recording_visualizer/logfile_processor/models/metadata_log.dart';
import 'package:bloc/bloc.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:flutter/foundation.dart';

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

  bool isValid(String fileName) {
    return fileName.endsWith(extension);
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

  void reset() {
    _safeEmit(const FileLoaderInitial());
  }

  Future<void> loadFile({
    XFile? file,
  }) async {
    if (state is FileLoaderLoading) {
      return;
    }

    _safeEmit(const FileLoaderLoading());

    if (file == null) {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [fileLoaderType.extension],
        // only load file contents if it's a json file
        withData: fileLoaderType == FileLoaderType.json,
      );

      if (pickedFile == null) {
        _safeEmit(const FileLoaderError());
        return;
      }

      final file = pickedFile.files.single;
      _safeEmit(FileLoaderLoaded(file));
    } else {
      final platformFile = await file.toPlatformFile(
        loadData: fileLoaderType == FileLoaderType.json,
      );
      _safeEmit(FileLoaderLoaded(platformFile));
    }
  }

  Future<void> getLogRemotely(String uuid) async {
    final state = this.state;
    if (state is FileLoaderLoading) {
      return;
    }

    final expectedFileName = 'log.$uuid.json';
    if (state is FileLoaderLoadedRemotely) {
      if (state.file.name == expectedFileName) {
        // already loaded
        return;
      }
    }

    _safeEmit(const FileLoaderLoading());

    Uint8List? metadata;
    try {
      metadata = await FirebaseStorage.instance
          .ref()
          .child('logs')
          .child(expectedFileName)
          .getData();
    } on StorageException {
      _safeEmit(const FileLoaderErrorRemoteNotFound());
      return;
    }

    if (metadata == null) {
      _safeEmit(const FileLoaderErrorRemoteNotFound());
      return;
    }

    final file = PlatformFile(
      name: expectedFileName,
      size: metadata.length,
      path: expectedFileName,
      bytes: metadata.buffer.asUint8List(),
    );

    _safeEmit(FileLoaderLoadedRemotely(file));
  }

  void _safeEmit(FileLoaderState state) {
    if (!isClosed) {
      emit(state);
    }
  }
}

extension ToPlatformFile on XFile {
  Future<PlatformFile> toPlatformFile({
    bool loadData = false,
  }) async {
    if (loadData) {
      final bytes = await readAsBytes();
      return PlatformFile(
        name: name,
        size: bytes.length,
        path: path,
        bytes: bytes,
      );
    } else {
      final size = await length();
      return PlatformFile(
        name: name,
        size: size,
        path: path,
      );
    }
  }
}
