import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin AppColors {
  static const Color greenPrime = Color(0xff00B74F);
  static const Color bluePrime = Color(0xff1D4289);
  static const Color backgroundColor =
      Color.fromRGBO(237, 241, 246, 1.0); //Color(0xffEDF6F7);
  static const Color whiteColor = Color(0xffFFFFFF);
  static const kColorDivider = Color(0xffEDF1F6);
  static const Color redColor = Color(0xffFF6763);
  static const Color hintText = Color(0xff999999);
  static const Color greyText = Color(0xff666666);
  static const Color titleColorText = Color(0xff333333);
  static const Color dividerColor = Color(0xffBACDDF);
  static const Color titleColor = Color(0xff146A76);
  static Color gTextColor = const Color.fromRGBO(102, 102, 103, 1.0);
  static Color slateGrey2 = const Color.fromRGBO(102, 102, 103, 0.9);
  static Color gDisableTextColor = const Color.fromRGBO(102, 102, 103, 0.4);
  static Color gRedTextColor = const Color.fromRGBO(255, 103, 99, 1.0);
  static Color gPrimaryColor = const Color.fromRGBO(0, 183, 79, 1.0);
  static const kIncreaseMoneyColor = Color.fromRGBO(0, 183, 79, 1);
  static Color shimmerBackGroundColor = Colors.black.withOpacity(0.2);
  static Color shimmerItemColor = const Color(0xff666667);
  static Color shimmerBaseColor = Colors.grey.shade300;
  static Color shimmerImageColor = Colors.grey.shade100;
  static Color shimmerOpaqueBaseColor = const Color(0xBDD6D6D6);
  static Color shimmerHighlightColor = Colors.grey.shade400;

  static const LinearGradient gradientColor = LinearGradient(
      colors: [
        Color(0xFF1D4289),
        Color(0xFF00B74F),
      ],
      begin: FractionalOffset(0.0, 0.0),
      end: FractionalOffset(1.0, 0.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);

  static const LinearGradient kGradientBackgroundFirstAction = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.topRight,
    // ignore: always_specify_types
    colors: [
      Color(0xFF1D4289),
      Color(0xFF00B74F),
    ],
  );

  static const kBoxShadow = BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0);
}
