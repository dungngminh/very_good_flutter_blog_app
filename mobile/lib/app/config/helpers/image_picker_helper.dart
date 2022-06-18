import 'package:image_picker/image_picker.dart';

abstract class ImagePickerHelper {
  static final _picker = ImagePicker();

  static Future<String?> pickImageFromSource(ImageSource source) async {
    try {
      final image = await _picker.pickImage(source: source);
      if (image != null) {
        return image.path;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
