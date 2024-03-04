import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

ThemeData get lightMode => ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: lightIconColor,
      ),
      textTheme: TextTheme(
        displayMedium: TextStyle(
          color: Colors.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          fontFamily: "Cairo",
        ),
      ),
      hoverColor: lightScaffold,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: indicatorColor,
          unselectedItemColor: Colors.grey[400],
          selectedIconTheme: const IconThemeData(
            color: indicatorColor,
          )),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
            backgroundColor:
                const MaterialStatePropertyAll<Color>(Colors.transparent),
            elevation: const MaterialStatePropertyAll<double>(0),
            iconColor: const MaterialStatePropertyAll<Color>(Colors.white),
            textStyle: MaterialStateProperty.all<TextStyle>(
              const TextStyle(
                color: Colors.white,
              ),
            )),
      ),
      elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
            elevation: MaterialStatePropertyAll<double>(0),
            backgroundColor: MaterialStatePropertyAll<Color>(indicatorColor),
            padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.all(10)),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))))),
      ),
      cardColor: lightAppBar,
      canvasColor: lightIconColor,
      indicatorColor: indicatorColor,
      appBarTheme: AppBarTheme(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        color: indicatorColor,
        toolbarHeight: 50.h,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 10.h),
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: indicatorColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: lightChatBox,
        iconColor: lightText,
        isCollapsed: true,
        filled: false,
      ),
    );

TextStyle get lightTextStyle => const TextStyle(
      color: lightText,
      height: 2,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    );
