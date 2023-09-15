class StorageFile {
  final String name;
  final String path;

  StorageFile({
    required this.name,
    required this.path,
  });

  StorageFile.fromJson(Map<String, dynamic> object)
      : name = object['name'],
        path = object['path'] ?? '';

  Map<String, dynamic> toJson() => {
        'name': name,
        'path': path,
      };
}
