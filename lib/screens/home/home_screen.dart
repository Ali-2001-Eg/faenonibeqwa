import 'package:faenonibeqwa/controllers/meeting_controller.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  static const String routeName = '/home';
  HomeScreen({super.key});

  final TextEditingController _meetingIdController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('فَأَعِينُونِي بِقُوَّةٍ'),
        actions: [
          IconButton(
              onPressed: () =>
                  ref.read(meetingControllerProvider).createMeeting(context),
              tooltip: 'قم بإنشاء محادثه بينك و بين أصدقائك',
              icon: const Icon(
                Icons.call,
                color: Colors.teal,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BigText(text: ' للإنضمام لمكالمه جاريه :'),
            10.verticalspace,
            _joinMeetingTextField(context, ref),
          ],
        ),
      ),
    );
  }

  TextField _joinMeetingTextField(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: _meetingIdController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: [
        // Match the pattern described: 3h9l-ecew-jho9
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9a-z\-]*$')),
        LengthLimitingTextInputFormatter(15), // Set a character limit
      ],
      decoration: InputDecoration(
          hintText: 'رمز المكالمه',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              width: 2,
            ),
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.login_rounded,
              color: Colors.teal,
            ),
            onPressed: () => _joinMeeting(ref, context),
          )),
    );
  }

  void _joinMeeting(WidgetRef ref, BuildContext context) {
    if (_meetingIdController.text.isEmpty) {
      customSnackbar(
        context: context,
        text: 'اكتب الرمز من فضلك',
      );
      return;
    } else {
      ref.read(meetingControllerProvider).joinMeeting(
            context,
            _meetingIdController.text.trim(),
          );
    }
  }
}
