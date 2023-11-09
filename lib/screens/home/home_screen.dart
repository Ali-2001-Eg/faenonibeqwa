import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/data/api_client.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/base/constants.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final TextEditingController _meetingIdController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('فَأَعِينُونِي بِقُوَّةٍ'),
        actions: [
          IconButton(
              onPressed: () => _onCreateButtonPressed(context),
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
            _joinMeetingTextField(context),
          ],
        ),
      ),
    );
  }

  TextField _joinMeetingTextField(BuildContext context) {
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
            onPressed: () => _meetingIdController.text.isEmpty
                ? customSnackbar(
                    context: context,
                    text: 'اكتب الرمز من فضلك',
                  )
                : _onJoinButtonPressed(context),
          )),
    );
  }

  void _onCreateButtonPressed(BuildContext context) async {
    // call api to create meeting and then navigate to MeetingScreen with meetingId,token
    await ApiClient.createMeeting().then((meetingId) {
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MeetingScreen(
            conferenceID: meetingId,
            token: AppConstants.videosdkToken,
          ),
        ),
      );
    });
  }

  void _onJoinButtonPressed(BuildContext context) {
    String meetingId = _meetingIdController.text;
    var re = RegExp("\\w{4}\\-\\w{4}\\-\\w{4}");
    // check meeting id is not null or invaild
    // if meeting id is vaild then navigate to MeetingScreen with meetingId,token
    if (meetingId.isNotEmpty && re.hasMatch(meetingId)) {
      _meetingIdController.clear();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MeetingScreen(
            conferenceID: meetingId,
            token: AppConstants.videosdkToken,
          ),
        ),
      );
    } else {
      customSnackbar(
        context: context,
        text: "لا توجد اي غرف بالرمز ${_meetingIdController.text}",
      );
    }
  }
}
