import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

typedef PathCallback = void Function(String path);

class ImageCropperPicker {
  final int _selected;

  ImageCropperPicker(this._selected);

  Future<File> filePicker() async {
    PickedFile pickedFile;
    if (0 == _selected) {
      pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        maxWidth: 1080,
      );
    }
    if (1 == _selected) {
      pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxHeight: 1080,
        maxWidth: 1080,
      );
    }
    if (pickedFile == null) return null;
    return ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      cropStyle: CropStyle.circle,
      maxHeight: 512,
      maxWidth: 512,
    );
  }
}

class UtilsImage {
  // Crop Image
  static Future<File> _cropImage(filePath) {
    return ImageCropper.cropImage(
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      sourcePath: filePath,
      maxHeight: 512,
      maxWidth: 512,
    );
  }

  static Future<File> getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    return _cropImage(pickedFile.path);
  }

  static Future<File> getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    return _cropImage(pickedFile.path);
  }
}
