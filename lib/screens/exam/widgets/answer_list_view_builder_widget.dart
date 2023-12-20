import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswersListWiewBuilderWidget extends StatefulWidget {
  const AnswersListWiewBuilderWidget({super.key});

  @override
  State<AnswersListWiewBuilderWidget> createState() =>
      _AnswersListWiewBuilderWidgetState();
}

class _AnswersListWiewBuilderWidgetState
    extends State<AnswersListWiewBuilderWidget> {
  final List<TextEditingController> _answerControllers =
      List.generate(4, (index) => TextEditingController());
  @override
  void dispose() {
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 4,
      shrinkWrap: true,
      // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (_, i) =>
          Padding(padding: EdgeInsets.all(10.w), child: Container()),
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // SmallText(text: index.toString(), fontWeight: FontWeight.w700),
            Container(
                constraints: BoxConstraints(
                  minWidth: 30,
                  maxWidth: context.screenWidth - 60,
                  maxHeight: 200,
                  minHeight: 50,
                ),
                child: CustomTextField(
                  controller: _answerControllers[index],
                  hintText: index == 0
                      ? 'أ'
                      : index == 1
                          ? 'ب'
                          : index == 2
                              ? 'ج'
                              : 'د',
                ))
          ],
        );
      },
    );
  }
}
