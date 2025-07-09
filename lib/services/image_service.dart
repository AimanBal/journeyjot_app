//services/image_service.dart
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

class ImageService {
  final _picker = ImagePicker();
  final Box imageBox = Hive.box('imageBox'); // Open a Hive box for images

  Future<XFile?> pickImage({bool fromCamera = false}) async {
    return await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
  }

  Future<void> saveImageLocally(XFile imageFile) async {
    final id = const Uuid().v4();
    final bytes = await imageFile.readAsBytes(); // Convert XFile to bytes

    imageBox.put(id, bytes); // Save image bytes locally in Hive
  }

  Uint8List? getImage(String id) {
    return imageBox.get(id); // Retrieve image bytes by ID
  }
}
