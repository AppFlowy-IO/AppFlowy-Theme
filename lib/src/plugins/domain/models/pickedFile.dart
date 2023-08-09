import 'dart:typed_data';

class PickedFile {
  final Uint8List bytes;
  final String name;

  const PickedFile(this.bytes, this.name);
}