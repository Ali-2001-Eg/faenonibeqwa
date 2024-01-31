// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../utils/shared/widgets/big_text.dart';

// ignore: must_be_immutable
class QuestionAnswers extends StatefulWidget {
  const QuestionAnswers({
    Key? key,
  }) : super(key: key);

  @override
  State<QuestionAnswers> createState() => _QuestionAnswersState();
}

class _QuestionAnswersState extends State<QuestionAnswers> {
  int? currentValue;
  List answers = [
    "الجيزه",
    "القاهره",
    "الاسكندرية",
    "مطروح",
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: answers.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              currentValue = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 250,
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  width: currentValue == index ? 1.5 : 0.5,
                  color: currentValue == index ? Colors.green : Colors.black),
            ),
            child: Row(
              children: [
                BigText(
                  text: answers[index],
                  fontSize: 18,
                ),
                const Spacer(),
                if (currentValue == index)
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.check,
                      size: 25,
                      color: Colors.white,
                    ),
                  )
                else
                  const SizedBox.shrink()
              ],
            ),
          ),
        );
      },
    );
  }
}
