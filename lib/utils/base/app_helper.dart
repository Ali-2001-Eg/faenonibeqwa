import 'dart:async';
import 'dart:io';
import 'package:faenonibeqwa/utils/shared/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AppHelper {
  //pick image
  static FutureOr<CroppedFile?> pickImage(BuildContext context,
      {ImageSource imageSource = ImageSource.gallery}) async {
    CroppedFile? image;
    try {
      final pickedImage = await ImagePicker().pickImage(source: imageSource);

      if (pickedImage != null) {
        image = await cropImage(File(pickedImage.path));
      }

      return image;
    } catch (e) {
      if (context.mounted) customSnackbar(context: context, text: e.toString());
    }
    return null;
  }

  //crop image
  static FutureOr<CroppedFile?> cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        compressQuality: 100,
        maxWidth: 800,
        maxHeight: 800,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        ]);

    return croppedFile;
  }
}
