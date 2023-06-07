part of 'file_loader_cubit.dart';

@immutable
abstract class FileLoaderState {
  const FileLoaderState();
}

class FileLoaderInitial extends FileLoaderState {
  const FileLoaderInitial();
}

class FileLoaderLoading extends FileLoaderState {
  const FileLoaderLoading();
}

class FileLoaderLoaded extends FileLoaderState {
  const FileLoaderLoaded(this.file);

  final PlatformFile file;

  /// Throws an error if the file's contents is null
  Future<MetadataLog> parseMetadata() async {
    final decoded = await compute(utf8.decode, file.bytes!);
    return compute(parseMetadataLog, decoded);
  }

  /// Throws an error if file's contents is null
  MetadataLog parseMetadataSync() {
    final decoded = utf8.decode(file.bytes!);
    return parseMetadataLog(decoded);
  }

  String? uuid() {
    final uuidRegex = RegExp(
      r'\b[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\b',
    );

    return uuidRegex.firstMatch(file.name)?.group(0);
  }
}

class FileLoaderLoadedRemotely extends FileLoaderLoaded {
  const FileLoaderLoadedRemotely(super.file);
}

class FileLoaderError extends FileLoaderState {
  const FileLoaderError();
}

class FileLoaderErrorRemoteNotFound extends FileLoaderError {
  const FileLoaderErrorRemoteNotFound();
}
