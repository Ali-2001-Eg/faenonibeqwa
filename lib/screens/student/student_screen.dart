import 'package:faenonibeqwa/models/user_model.dart';
import 'package:faenonibeqwa/screens/exam/solute_exam/widgets/shimmer_widget.dart';
import 'package:faenonibeqwa/utils/providers/app_providers.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:faenonibeqwa/utils/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/student_item.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'بيانات الطلاب'),
      body: Column(
        children: [
          Expanded(child: Consumer(
            builder: (context, ref, child) {
              return ref.watch(usersStream).when(data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    UserModel user = data[index];
                    return StudentItem(
                      name: user.name,
                      id: user.uid,
                    );
                  },
                );
              }, error: (e, s) {
                return BigText(text: e.toString());
              }, loading: () {
                return const ShimmerWidget(
                  cardsNumber: 6,
                );
              });
            },
          ))
        ],
      ),
    );
  }
}
