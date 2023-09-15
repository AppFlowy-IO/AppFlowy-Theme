part of 'storage_bloc.dart';

abstract class StorageEvent {
  const StorageEvent();

}

class UploadFileRequested extends StorageEvent {
  const UploadFileRequested({required this.user, required this.plugin, required this.price});

  final User user;
  final PickedFile plugin;
  final double price;

}

class DeleteFileRequested extends StorageEvent {
  const DeleteFileRequested({required this.fileName, required this.user, required this.bucket});

  final User user;
  final String fileName;
  final String bucket;
}

class StorageReloadRequested extends StorageEvent {
  StorageReloadRequested();
}

class GetUploadedFilesRequested extends StorageEvent {
  GetUploadedFilesRequested({this.searchTerm, required this.uid, required this.bucket});

  final String uid;
  final String bucket;
  final String? searchTerm;
}
