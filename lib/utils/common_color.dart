import 'package:flutter/material.dart';

AppColors color = AppColors();

class AppColors {

  Color transparentColor = Colors.transparent;
  Color white = Colors.white;
  Color black = Colors.black;
  Color appColor = const Color(0xff293FE3);
  LinearGradient appGradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xff9810FA),
      Color(0xff4F39F6),
    ],
  );
  Color backgroundColor = const Color(0xffF9F9F9);
  Color textFieldErrorColor = const Color(0xffFF7373);
  Color textFieldTextColor = const Color(0xff4B5563);
  Color textFieldFocusColor = const Color(0xff1BA345);
  Color onboardingBorderColor = const Color(0xffE5E7EB);
  Color onboardingTextColor = const Color(0xff9CA3AF);
  Color containerBackgroundColor = const Color(0xff3E52E6);
  Color homeTextColor = const Color(0xffDFE3EA);
  Color notificationContainerColor = const Color(0xffE9ECF1);
  Color dividerColor = const Color(0xffF0F1F2);
  Color divider2Color = const Color(0xffE9E9E9);
  Color cancelColor = const Color(0xff6B7280);
  Color buttonColor = const Color(0xffFFB30B);
  Color presentBackgroundColor = const Color(0xffE8F6EC);
  Color absentBackgroundColor = const Color(0xffFFDED8);
  Color waitingBackgroundColor = const Color(0xffFFF4DA);
  Color waitingColor = const Color(0xffFF6700);
  Color editTextColor = const Color(0xff7C7C7C);
  Color classContainerColor = const Color(0xffFFE8D9);
  Color chatTimeTextColor = const Color(0xff6C737F);
  Color leaveCalenderColor = const Color(0xffD1D5DB);
  Color calenderColor = const Color(0xffB3B7BD);
  Color timeColor = const Color(0xff737373);
  Color pendingColor = const Color(0xffBF8608);
  Color addMenuColor = const Color(0xff6B757D);
  Color primaryColor = Color(0xff152E4B);
  Color warnRedColor = const Color(0xffF05251);
  Color viewStudentsColor = const Color(0xffFFF7E7);
}
