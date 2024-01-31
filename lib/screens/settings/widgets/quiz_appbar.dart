import 'package:flutter/material.dart';

import '../../../utils/shared/widgets/big_text.dart';

class QuizAppBar extends StatelessWidget {
  const QuizAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14, left: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                BigText(
                  text: '14:59',
                  color: Colors.white,
                  fontSize: 16,
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.watch_later_rounded,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const BigText(
            text: 'Quiz ',
            color: Colors.white,
          ),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.deepOrange,
            child: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
