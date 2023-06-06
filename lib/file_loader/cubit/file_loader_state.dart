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
}

class FileLoaderError extends FileLoaderState {
  const FileLoaderError();
}
