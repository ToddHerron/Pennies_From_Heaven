import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  // Returns a [File] object pointing to the image that was picked.
  Future<File> pickImage({/*required*/ required ImageSource source}) async {
    return File((await ImagePicker().getImage(source: source))!.path);
  }
}
