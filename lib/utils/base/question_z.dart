//to grab question data

import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/exam_model.dart';
import '../shared/widgets/big_text.dart';
import '../shared/widgets/small_text.dart';

class QuestionZ {
  TextEditingController questionBodyController = TextEditingController();
  CroppedFile? questionImage;
  List<TextEditingController> answerControllers =
      List.generate(4, (index) => TextEditingController());
  int correctAnswerIndex = 0;
  String? imageUrl;
  Question convertToQuestion() {
    List<Answers> answersList = List.generate(
      4,
      (index) => Answers(
        identifier: (index + 1).toString(),
        answer: answerControllers[index].text,
      ),
    );

    return Question(
      body: questionBodyController.text,
      correctAnswerIdentifier: answersList[correctAnswerIndex].identifier,
      questionImage: questionImage == null ? null : imageUrl,
      answers: answersList,
    );
  }
  // Future<String> uploadImage(CroppedFile? file, String? imageUrl) async {
  //   if (file != null) {
  //     final String fileName = const Uuid().v4(); // Generate a unique filename
  //     final Reference ref =
  //         FirebaseStorage.instance.ref().child('images/$fileName');
  //     final UploadTask uploadTask = ref.putFile(File(questionImage!.path));

  //     await uploadTask.whenComplete(() {});

  //     imageUrl = await ref.getDownloadURL();
  //     return imageUrl;
  //   }
  //   return '';
  // }

  Future<void> pickQuestionImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const BigText(text: 'اختر مصدر الصوره'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                CroppedFile? image = await AppHelper.pickAndEditImage(context,
                    imageSource: ImageSource.camera);

                questionImage = image;

                if (context.mounted) Navigator.pop(context);
              },
              child: const SmallText(text: 'كاميرا'),
            ),
            TextButton(
              onPressed: () async {
                CroppedFile? image = await AppHelper.pickAndEditImage(context,
                    imageSource: ImageSource.gallery);

                questionImage = image;

                if (context.mounted) Navigator.pop(context);
              },
              child: const SmallText(text: 'المعرض'),
            ),
          ],
        );
      },
    );
  }
}
