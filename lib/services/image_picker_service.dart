import 'package:image_picker/image_picker.dart';
// Service to help with image picking for profile and reviews
class ImagePickerService {
  // Uses image_picker to pick an image and returns its file path
  Future<String?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile.path;
    }
    return null;
  }
}
