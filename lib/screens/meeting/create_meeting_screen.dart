import 'dart:math';

import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:faenonibeqwa/utils/base/app_helper.dart';
import 'package:faenonibeqwa/utils/extensions/sized_box_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/notification_model.dart';
import '../../utils/providers/app_providers.dart';

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
      appBar: const CustomAppBar(title: 'إنشاء مكالمه جماعيه'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: TextField(
                style: const TextStyle(color: Colors.black),
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
            50.hSpace,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 100),
              ),
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  var channeld = Random().nextInt(10000).toString();

                  ref
                      .read(meetingControllerProvider)
                      .startMeeting(
                        title: _titleController.text.trim(),
                        // isBrodcater: true,
                        channelId: channeld,
                      )
                      .then((value) {
                        ref
                            .watch(notificationRepoProvider)
                            .sendPremiumNotification(
                              'استعدوا للبث المباشر',
                              '${_titleController.text.trim()} 🎧📺⏳',
                              notifcationData: NotifcationModel(
                                time: DateTime.now().toString(),
                              ),
                            );
                      })
                      .then((value) => Navigator.pushNamed(
                            context,
                            MeetingScreen.routeName,
                            arguments: {
                              'channelId': channeld,
                              'userID': ref
                                  .watch(authControllerProvider)
                                  .userInfo
                                  .uid,
                              'isBroadcaster': true,
                              'title': _titleController.text.trim(),
                            },
                          ))
                      .catchError((err) {
                        AppHelper.customSnackbar(
                            context: context, title: err.toString());
                        return err;
                      });
                } else {
                  AppHelper.customSnackbar(
                      context: context, title: 'ضع عنونا للمكالمه');
                }
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
