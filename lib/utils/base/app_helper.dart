import 'dart:async';
import 'dart:io';
import 'package:faenonibeqwa/utils/enums/toast_enum.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      if (context.mounted) {
        customSnackbar(context: context, title: e.toString());
      }
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
      if (context.mounted) {
        customSnackbar(context: context, title: e.toString());
      }
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

  static void customSnackbar({
    required BuildContext context,
    required String title,
    ToastStatus status = ToastStatus.error,
    ToastGravity snackbarPosition = ToastGravity.BOTTOM,
  }) {
    Color color;
    switch (status) {
      case ToastStatus.success:
        color = context.theme.appBarTheme.backgroundColor!;
        break;
      case ToastStatus.warning:
        color = const Color.fromARGB(255, 179, 117, 24);
        break;
      case ToastStatus.error:
        color = Colors.red;
        break;
    }

    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_SHORT,
        gravity: snackbarPosition,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
