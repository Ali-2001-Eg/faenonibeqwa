import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AppHelper {
  //pick image
  static FutureOr<File?> pickImage(BuildContext context,
      {ImageSource imageSource = ImageSource.gallery}) async {
    File? image;
    try {
      final pickedImage = await ImagePicker().pickImage(source: imageSource);

      if (pickedImage != null) {
        image = File(pickedImage.path);
      }

      return image;
    } catch (e) {
      if (context.mounted) customSnackbar(context: context, text: e.toString());
    }
    return null;
  }

  static FutureOr<CroppedFile?> pickAndEditImage(BuildContext context,
      {ImageSource imageSource = ImageSource.gallery}) async {
    CroppedFile? image;
    try {
      final pickedImage = await ImagePicker().pickImage(source: imageSource);

      if (pickedImage != null) {
        image = await _cropImage(File(pickedImage.path));
      }

      return image;
    } catch (e) {
      if (context.mounted) customSnackbar(context: context, text: e.toString());
    }
    return null;
  }

  //crop image
  static FutureOr<CroppedFile?> _cropImage(File imageFile) async {
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

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      customSnackbar(
          {required BuildContext context,
          required String text,
          Color color = Colors.redAccent}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      shape: const StadiumBorder(),
      elevation: 0,
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(3),
      backgroundColor: color,
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15.h, color: Colors.white),
      ),
    ));
  }
}
