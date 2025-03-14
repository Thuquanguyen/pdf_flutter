import 'package:flutter/cupertino.dart';

extension ExtendedTextStyle on TextStyle {
  // Color

  TextStyle get lightTextColor {
    return copyWith(color: const Color(0xFFFFFFFF));
  }

  TextStyle get highlightColor {
    return copyWith(color: const Color(0xFF00B74F));
  }

  TextStyle get colorAppBar {
    return copyWith(color: const Color(0xFF146A76));
  }

  TextStyle get secondaryTextColor {
    return copyWith(color: const Color(0xFF999999));
  }

  TextStyle get primaryTextColor {
    return copyWith(color: const Color(0xFF222222));
  }

  TextStyle get contentTextColor {
    return copyWith(color: const Color(0xFF565656));
  }

  TextStyle get successColor {
    return copyWith(color: const Color(0xFF33CC7F));
  }

  TextStyle get infoColor {
    return copyWith(color: const Color(0xFF4DB9E9));
  }

  TextStyle get warningColor {
    return copyWith(color: const Color(0xFFFFBE40));
  }

  TextStyle get errorColor {
    return copyWith(color: const Color(0xFFF46666));
  }

  // FontSize
  TextStyle get tiny {
    return copyWith(fontSize: 12);
  }

  TextStyle get small {
    return copyWith(fontSize: 13);
  }

  TextStyle get normal {
    return copyWith(fontSize: 14);
  }

  TextStyle get medium {
    return copyWith(fontSize: 17);
  }

  TextStyle get large {
    return copyWith(fontSize: 21);
  }

  // FontWeight
  TextStyle get thin {
    return copyWith(fontWeight: FontWeight.w200);
  }

  TextStyle get light {
    return copyWith(fontWeight: FontWeight.w300);
  }

  TextStyle get w500 {
    return copyWith(fontWeight: FontWeight.w500);
  }

  TextStyle get semiBold {
    return copyWith(fontWeight: FontWeight.w600);
  }

  TextStyle get bold {
    return copyWith(fontWeight: FontWeight.bold);
  }

  // Font style
  TextStyle get italic {
    return copyWith(fontStyle: FontStyle.italic);
  }

  TextStyle get underline {
    return copyWith(decoration: TextDecoration.underline);
  }

  TextStyle setColor(Color color) {
    return copyWith(color: color);
  }

  TextStyle setFontWeight(FontWeight fontWeight) {
    return copyWith(fontWeight: fontWeight);
  }

  TextStyle setTextSize(double size) {
    return copyWith(fontSize: size);
  }

  TextStyle setLineHeight(double height) {
    return copyWith(height: height);
  }
}

class TextStyles {
  static const double _height = 1.4;

  static const TextStyle defaultStyle = TextStyle(
      fontSize: 14,
      color: Color(0xFF333333),
      height: _height,
      fontWeight: FontWeight.normal,
      fontFamily: 'SVN-Gilroy');

  /// Text use for small text like: note, guideline text, ...
  ///
  /// Default: size: 20, weight: W600
  static TextStyle appBarText = defaultStyle.colorAppBar.semiBold.large;

  /// Text use for small text like: note, guideline text, ...
  ///
  /// Default: size: 16, weight: W600
  static TextStyle headerText = defaultStyle.primaryTextColor.semiBold.medium;

  /// Text use for small text like: note, guideline text, ...
  ///
  /// Default: size: 12, weight: W400
  static TextStyle secondaryText = defaultStyle.secondaryTextColor.thin.small;

  /// Text use for small text like: note, guideline text, ...
  ///
  /// Default: size: 13, weight: W600
  static TextStyle primaryText = defaultStyle.primaryTextColor.normal;
}
