// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:faenonibeqwa/controllers/meeting_controller.dart';
// import 'package:faenonibeqwa/models/meeting_model.dart';
// import 'package:faenonibeqwa/screens/meeting/meeting_screen.dart';
// import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:timeago/timeago.dart' as timeago;

// import '../../responsive/responsive_layout.dart';
// import 'custom_indicator.dart';

// class FeedWidget extends ConsumerStatefulWidget {
//   const FeedWidget({Key? key}) : super(key: key);

//   @override
//   ConsumerState<FeedWidget> createState() => _FeedWidgetState();
// }

// class _FeedWidgetState extends ConsumerState<FeedWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(
//           top: 10,
//         ),
//         child: StreamBuilder<dynamic>(
//           stream: FirebaseFirestore.instance.collection('meeting').snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const LoadingIndicator();
//             }

//             return ResponsiveLayout(
//               desktopBody: GridView.builder(
//                 itemCount: snapshot.data.docs.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                 ),
//                 itemBuilder: (context, index) {
//                   MeetingModel post =
//                       MeetingModel.fromMap(snapshot.data.docs[index].data());
//                   return InkWell(
//                     onTap: () async {
//                      /*  await ref
//                           .read(meetingControllerProvider)
//                           .updateViewCount(post.channelId, true); */
//                       if (mounted) {
//                         print('channel id is  ${post.channelId}');
// /*                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => MeetingScreen(
                              
//                             ),
//                           ),
//                         ); */
//                       }
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 10,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             height: size.height * 0.35,
//                             child: Image.network(
//                               post.image,
//                               fit: BoxFit.contain,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 post.username,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                               Text(
//                                 post.title,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text('${post.viewers} watching'),
//                               Text(
//                                 'Started ${timeago.format(post.startedAt)}',
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               mobileBody: ConstrainedBox(
//                 constraints:
//                     BoxConstraints(maxHeight: context.screenHeight / 3),
//                 child: ListView.builder(
//                     itemCount: snapshot.data.docs.length,
//                     itemBuilder: (context, index) {
//                       MeetingModel post = MeetingModel.fromMap(
//                           snapshot.data.docs[index].data());

//                       return InkWell(
//                         onTap: () async {
//                          /*  await ref
//                               .read(meetingControllerProvider)
//                               .updateViewCount(post.channelId, true); */
//                           if (mounted) {
//                             /* Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => MeetingScreen(

//                                 ),
//                               ),
//                             ); */
//                           }
//                         },
//                         child: Container(
//                           height: size.height * 0.1,
//                           margin: const EdgeInsets.symmetric(vertical: 10),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               AspectRatio(
//                                 aspectRatio: 16 / 9,
//                                 child: Image.network(post.image),
//                               ),
//                               const SizedBox(width: 10),
//                               Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     post.username,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20,
//                                     ),
//                                   ),
//                                   Text(
//                                     post.title,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text('${post.viewers} watching'),
//                                   Text(
//                                     'Started ${timeago.format(post.startedAt)}',
//                                   ),
//                                 ],
//                               ),
//                               IconButton(
//                                 onPressed: () {},
//                                 icon: const Icon(
//                                   Icons.more_vert,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
