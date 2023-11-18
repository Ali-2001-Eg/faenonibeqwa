import 'package:faenonibeqwa/controllers/meeting_controller.dart';
import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/base/app_helper.dart';
import '../../utils/responsive/responsive.dart';
import '../../utils/shared/widgets/custom_button.dart';
import '../../utils/shared/widgets/meeting_title_text_field.dart';

class CreateMeetingScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-meeting';
  const CreateMeetingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateMeetingScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends ConsumerState<CreateMeetingScreen> {
  final TextEditingController _titleController = TextEditingController();
  Uint8List? image;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> goLiveStream() async {
    await ref
        .read(meetingControllerProvider)
        .startMeeting(context, _titleController.text, image)
        .then((value) {
      print('channel id is  $value');
      if (value.isNotEmpty && mounted) {
        customSnackbar(
          context: context,
          text: 'Livestream has started successfully!',
          color: Colors.green,
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MeetingScreen(
              isBroadcaster: true,
              channelId: value,
            ),
          ),
        );
      }
      return value;
    }).catchError((err) {
      customSnackbar(context: context, text: 'Error: ${err.message}');
      return err;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Responsive(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Uint8List? pickedImage = await AppHelper.pickImage();
                          if (pickedImage != null) {
                            setState(() {
                              image = pickedImage;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22.0,
                            vertical: 20.0,
                          ),
                          child: image != null
                              ? SizedBox(
                                  height: 300,
                                  child: Image.memory(image!),
                                )
                              : DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  color: context.theme.cardColor,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: context.theme.cardColor
                                          .withOpacity(.05),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.folder_open,
                                          color: context.theme.cardColor,
                                          size: 40,
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          'Select your thumbnail',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey.shade400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      50.verticalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Title',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: CustomTextField(
                              controller: _titleController,
                              hint: 'Title',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  50.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: CustomButton(
                      text: 'Go Live!',
                      onTap: () => goLiveStream(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
