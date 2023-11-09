import 'package:faenonibeqwa/utils/base/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData darkMode(context) => ThemeData.dark().copyWith(
      hoverColor: darkReplyColor,
      scaffoldBackgroundColor: backgroundColor,
      indicatorColor: tabColor,
      cardColor: messageColor,
      iconTheme: const IconThemeData(
        color: Colors.grey,
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          elevation: MaterialStatePropertyAll<double>(0),
          iconColor: MaterialStatePropertyAll<Color>(Colors.grey),
        ),
      ),
      appBarTheme: AppBarTheme(
        color: appBarColor,
        toolbarHeight: 50.h,
        titleTextStyle: TextStyle(color: Colors.grey, fontSize: 20.h),
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
        backgroundColor: tabColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
          filled: false,
          isCollapsed: true,
          fillColor: mobileChatBoxColor,
          iconColor: greyColor),
    );
TextStyle get darkTextStyle => const TextStyle(
      color: textColor,
      fontWeight: FontWeight.w500,
      height: 2,
      fontSize: 20,
    );
