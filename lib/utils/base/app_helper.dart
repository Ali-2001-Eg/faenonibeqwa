import 'dart:async';
import 'dart:io';
import 'package:faenonibeqwa/utils/shared/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

FutureOr<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }

    return image;
  } catch (e) {
    customSnackbar(context: context, text: e.toString());
  }
  return null;
}
