import 'package:faenonibeqwa/controllers/auth_controller.dart';
import 'package:faenonibeqwa/screens/auth/login_screen.dart';
import 'package:faenonibeqwa/utils/base/app_images.dart';
import 'package:faenonibeqwa/utils/extensions/context_extension.dart';
import 'package:faenonibeqwa/utils/shared/widgets/big_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/base/colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const BigText(
            text: 'الملف الشخصي',
            color: Colors.white,
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 40),
            customListTile(
              icon: Icons.paid_outlined,
              text: 'خطة الدفع',
              onTap: () {},
            ),
            customListTile(
              icon: Icons.person_outline_sharp,
              onTap: () {},
              text: 'تغير الصورة الشخصيه',
            ),
            customListTile(
              icon: Icons.logout,
              onTap: () {
                ref.read(authControllerProvider).signout.then((value) =>
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.routeName, (route) => false));
              },
              text: 'تسجيل الخروج',
            ),
          ],
        ));
  }

  Widget customListTile({
    required String text,
    required IconData icon,
    required void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
                height: 50,
                width: 60,
                decoration: const BoxDecoration(
                  color: lightButton,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                )),
            // ClipRRect(
            //   borderRadius: const BorderRadius.only(
            //     topRight: Radius.circular(16),
            //     bottomRight: Radius.circular(16),
            //   ),
            //   child: Image.asset(
            //     AppImages.tripImage,
            //   ),
            // ),
            const SizedBox(width: 20),
            BigText(
              text: text,
              fontSize: 15,
            )
          ],
        ),
      ),
    );
  }
}


// Center(
//         child: InkWell(
//           child: Text(
//             'Signout',
//             style: context.theme.textTheme.displayMedium,
//           ),
//           onTap: () => ref.read(authControllerProvider).signout.then((value) =>
//               Navigator.pushNamedAndRemoveUntil(
//                   context, LoginScreen.routeName, (route) => false)),
//         ),
//       ),