import 'dart:math';

import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/controllers/meeting_controller.dart';
import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:faenonibeqwa/utils/shared/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateMeetingScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-meeting-sceen';

  const CreateMeetingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends ConsumerState<CreateMeetingScreen> {
  final TextEditingController _titleController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  border: outlineBorder(),
                  enabledBorder: outlineBorder(),
                  errorBorder: outlineBorder(),
                  focusedBorder: outlineBorder(),
                  hintText: "عنوان المكالمه",
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 100),
              ),
              onPressed: () {
                var channeld = Random().nextInt(10000).toString();
                ref
                    .read(meetingControllerProvider)
                    .startMeeting(
                      title: _titleController.text.trim(),
                      isBrodcater: true,
                      channelId: channeld,
                    )
                    .then((value) => Navigator.pushNamed(
                          context,
                          MeetingScreen.routeName,
                          arguments: {
                            'channelId': channeld,
                            'userID':
                                ref.read(authControllerProvider).userInfo.uid,
                            'isBroadcaster': true,
                            'title':_titleController.text.trim(),
                          },
                        ))
                    .catchError((err) {
                  customSnackbar(context: context, text: err.toString());
                });
              },
              child: const Text(
                "ابدأ المكالمه",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder outlineBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.5),
      ),
    );
  }
}
