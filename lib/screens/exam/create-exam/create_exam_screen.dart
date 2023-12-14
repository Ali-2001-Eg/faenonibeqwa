import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'create_first_step.dart';
import 'create_second_step.dart';
import 'create_third_step.dart';

class CreateExamScreen extends ConsumerStatefulWidget {
  static const String routeName = "/create-exam-screen";
  const CreateExamScreen({super.key});

  @override
  ConsumerState<CreateExamScreen> createState() => _CreateExamScreenState();
}

int _currentStep = 0;

class _CreateExamScreenState extends ConsumerState<CreateExamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'إضافه اختبار'),
      body: Stepper(
        elevation: 0,
        connectorColor: MaterialStatePropertyAll(
            context.theme.appBarTheme.backgroundColor!),
        type: StepperType.vertical,
        currentStep: _currentStep,
        physics: const BouncingScrollPhysics(),
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        steps: _steps,
      ),
    );
  }

  void _onStepCancel() =>
      _currentStep == 0 ? null : setState(() => _currentStep--);

  void _onStepContinue() {
    bool isLastStep = _currentStep == _steps.length - 1;

    if (isLastStep) {
      debugPrint('indexed');
    } else {
      setState(() => _currentStep++);
    }
  }

  List<Step> get _steps => <Step>[
        Step(
          title: const SmallText(
            text: 'وصف الاختبار',
          ),
          state: _currentStep == 0 ? StepState.editing : StepState.indexed,
          isActive: _currentStep >= 0,
          content: CreateFirstStep(),
        ),
        Step(
          title: const SmallText(
            text: 'اسئله الاختبار',
          ),
          state: _currentStep == 1 ? StepState.editing : StepState.indexed,
          isActive: _currentStep >= 1,
          content: CreateSecondStep(),
        ),
        Step(
          title: const SmallText(
            text: 'إضافه الاختبار',
          ),
          isActive: _currentStep >= 2,
          state: _currentStep == 2 ? StepState.editing : StepState.indexed,
          content: CreateThirdStep(),
        ),
      ];
}
