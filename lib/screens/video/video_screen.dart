import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/base/colors.dart';
import 'video_details_screen.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BigText(text: 'فيديوهات الدروس'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return VideoDetailsScreen();
                      },
                    ));
                  },
                  child: Container(
                    height: 45.h,
                    margin: const EdgeInsets.all(8).r,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
                            .r,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        BigText(text: 'الدرس الاول '),
                        Icon(
                          Icons.video_collection_sharp,
                          color: lightButton,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
