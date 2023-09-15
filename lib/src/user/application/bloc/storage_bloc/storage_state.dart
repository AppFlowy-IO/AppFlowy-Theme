part of 'storage_bloc.dart';

abstract class StorageState {
  StorageState({List<PluginFileObject>? files}) : files = files ?? [];
  final List<PluginFileObject> files;
}

class StorageDefault extends StorageState {
  StorageDefault({super.files});
}


class StorageUploading extends StorageState {
  StorageUploading({super.files});

}

class StorageUploadSuccess extends StorageState {
  StorageUploadSuccess({super.files});

}


class StorageSearching extends StorageState {
  StorageSearching({super.files});

}

class StorageSearchSuccess extends StorageState {
  StorageSearchSuccess({required List<PluginFileObject> files}) : super(files: files);
}

class StorageDeletingFile extends StorageState {
  StorageDeletingFile({super.files});
}

class StorageDeleteSuccess extends StorageState {
  StorageDeleteSuccess({required List<PluginFileObject> files}) : super(files: files);
}

class StorageFailed extends StorageState {
  StorageFailed({required this.message});

  final String message;
}
