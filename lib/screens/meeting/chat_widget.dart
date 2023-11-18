import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faenonibeqwa/controllers/meeting_controller.dart';
import 'package:faenonibeqwa/utils/shared/widgets/meeting_title_text_field.dart';
import 'package:faenonibeqwa/utils/shared/widgets/small_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/shared/widgets/custom_indicator.dart';

class ChatWidget extends ConsumerStatefulWidget {
  final String channelId;
  const ChatWidget({
    Key? key,
    required this.channelId,
  }) : super(key: key);

  @override
  ConsumerState<ChatWidget> createState() => _ChatState();
}

class _ChatState extends ConsumerState<ChatWidget> {
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User userProvider = ref.read(authControllerProvider).userInfo;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width > 600 ? size.width * 0.25 : double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<dynamic>(
              stream: FirebaseFirestore.instance
                  .collection('meeting')
                  .doc(widget.channelId)
                  .collection('comments')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingIndicator();
                }

                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      snapshot.data.docs[index]['username'],
                      style: TextStyle(
                        color:
                            snapshot.data.docs[index]['uid'] == userProvider.uid
                                ? Colors.blue
                                : Colors.black,
                      ),
                    ),
                    subtitle: SmallText(
                      text: snapshot.data.docs[index]['message'],
                    ),
                  ),
                );
              },
            ),
          ),
          CustomTextField(
            controller: _chatController,
            hint: 'Type your message',
            onTap: (val) {
              ref.read(meetingControllerProvider).chat(
                    _chatController.text,
                    widget.channelId,
                    context,
                  );
              setState(() {
                _chatController.text = "";
              });
            },
          )
        ],
      ),
    );
  }
}
