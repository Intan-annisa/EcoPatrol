import 'package:image_picker/image_picker.dart';

class CameraService {
  static Future<XFile?> pickImageFromCamera() async {
    final picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.camera);
  }
}
