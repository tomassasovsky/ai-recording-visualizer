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
}

class FileLoaderError extends FileLoaderState {
  const FileLoaderError();
}
