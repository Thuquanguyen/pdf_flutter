import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app_core.dart';

class AppThemes {
  final String sThemeModeKey = 'S_THEME_MODE_KEY';
  final String _sThemeModeLight = '_sThemeModeLight';
  final String _sThemeModeDark = '_sThemeModeDark';
  static String Poppins = "Poppins";
  static String Roboto = "Roboto";
  static String QuicksandRegular = "QuicksandRegular";
  static String QuicksandMedium = "QuicksandMedium";
  static String OpenSansRegular = "OpenSansRegular";

  static String _fontFamily = Roboto;

  // LIGHT THEME TEXT
  static final TextTheme _lightTextTheme = TextTheme(
    overline: TextStyle(color: AppColor.TEXT_COLOR, fontFamily: _fontFamily),
    headline1: TextStyle(fontSize: 20.0, fontFamily: _fontFamily),
    bodyText1: TextStyle(fontSize: 16.0, fontFamily: _fontFamily),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: _fontFamily),
    button: TextStyle(fontSize: 15.0, fontFamily: _fontFamily),
    headline6: TextStyle(fontSize: 16.0, fontFamily: _fontFamily),
    subtitle1: TextStyle(fontSize: 16.0, fontFamily: _fontFamily),
    caption: TextStyle(fontSize: 12.0, fontFamily: _fontFamily),
  );

  // DARK THEME TEXT
  static final TextTheme _darkTextTheme = TextTheme(
    overline:
        TextStyle(color: AppColor.TEXT_COLOR_DARK, fontFamily: _fontFamily),
    headline1: TextStyle(fontSize: 20.0, fontFamily: _fontFamily),
    bodyText1: TextStyle(fontSize: 16.0, fontFamily: _fontFamily),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: _fontFamily),
    button: TextStyle(fontSize: 15.0, fontFamily: _fontFamily),
    headline6: TextStyle(fontSize: 16.0, fontFamily: _fontFamily),
    subtitle1: TextStyle(fontSize: 16.0, fontFamily: _fontFamily),
    caption: TextStyle(fontSize: 12.0, fontFamily: _fontFamily),
  );

  // LIGHT THEME
  static final ThemeData _lightTheme = ThemeData(
      backgroundColor: Colors.white,
      fontFamily: _fontFamily,
      primaryColor: AppColor.PRIMARY_COLOR,
      accentColor: AppColor.ACCENT_COLOR,
      scaffoldBackgroundColor: AppColor.LIGHT_BACKGROUND_COLOR,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColor.PRIMARY_COLOR,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Color(0XFF536A92),
        unselectedItemColor: Colors.red,
      ),
      bottomAppBarColor: Colors.white,
      appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        color: AppColor.PRIMARY_COLOR,
        iconTheme: IconThemeData(color: AppColor.ICON_COLOR),
      ),
      colorScheme: ColorScheme.light(
        primary: AppColor.PRIMARY_COLOR,
        primaryVariant: AppColor.PRIMARY_VARIANT,
      ),
      dividerTheme: DividerThemeData(color: AppColor.DARK_BACKGROUND_COLOR),
      snackBarTheme:
          SnackBarThemeData(backgroundColor: AppColor.LIGHT_BACKGROUND_COLOR),
      iconTheme: IconThemeData(
        color: AppColor.ICON_COLOR,
      ),
      popupMenuTheme:
          PopupMenuThemeData(color: AppColor.LIGHT_BACKGROUND_COLOR),
      textTheme: _lightTextTheme,
      cardColor: const Color(0XFFEE5A24),
      // canvasColor: Colors.black.withOpacity(0.1)
      canvasColor: Colors.black.withOpacity(0.1));

  // DARK THEME
  static final ThemeData _darkTheme = ThemeData(
      backgroundColor: const Color(0XFF252836),
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      primaryColor: AppColor.PRIMARY_DARK_COLOR,
      accentColor: AppColor.ACCENT_COLOR,
      scaffoldBackgroundColor: AppColor.DARK_BACKGROUND_COLOR,
      bottomAppBarColor: AppColor.DARK_BACKGROUND_COLOR,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColor.PRIMARY_DARK_COLOR,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Color(0XFF536A92),
        unselectedItemColor: Colors.red,
      ),
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        color: AppColor.PRIMARY_DARK_COLOR,
        iconTheme: IconThemeData(color: AppColor.ICON_COLOR_DARK),
      ),
      colorScheme: ColorScheme.dark(
        primary: AppColor.PRIMARY_DARK_COLOR,
        primaryVariant: AppColor.PRIMARY_VARIANT,
      ),
      dividerTheme: DividerThemeData(color: AppColor.LIGHT_BACKGROUND_COLOR),
      snackBarTheme:
          SnackBarThemeData(backgroundColor: AppColor.DARK_BACKGROUND_COLOR),
      iconTheme: IconThemeData(
        color: AppColor.ICON_COLOR_DARK,
      ),
      popupMenuTheme: PopupMenuThemeData(color: AppColor.DARK_BACKGROUND_COLOR),
      textTheme: _darkTextTheme,
      canvasColor: Colors.white,
      cardColor: Colors.white
      // canvasColor:  Colors.white
      );

  /// LIGHT THEME
  static ThemeData theme() {
    return _lightTheme;
  }

  /// DARK THEME
  static ThemeData darkTheme() {
    return _darkTheme;
  }

  ///
  /// [AppThemes] initiation.
  /// Please Add [AppThemes().init() into GetMaterialApp.
  ///
  /// [Example] :
  ///
  /// GetMaterialApp(
  ///   themeMode: AppThemes().init(),
  /// )
  ///
  /// This [Function] works to initialize what theme is used.
  ThemeMode init() {
    final box = GetStorage();
    String? tm = box.read(sThemeModeKey);
    if (tm == null) {
      box.write(sThemeModeKey, _sThemeModeLight);
      return ThemeMode.light;
    } else if (tm == _sThemeModeLight) {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }

  void changeThemeMode(ThemeMode themeMode) {
    final box = GetStorage();
    if (themeMode == ThemeMode.dark) {
      box.write(sThemeModeKey, _sThemeModeDark);
    } else {
      box.write(sThemeModeKey, _sThemeModeLight);
    }
    Get.changeThemeMode(themeMode);
    Get.rootController.themeMode.reactive;
  }

  ///
  /// [ThemeData] general.
  ///
  /// [Example] :
  ///
  /// Text("Hello, world",
  ///   style: AppThemes().general().textTheme.bodyText1,
  /// )
  ///
  /// This [Function] is useful for styling widgets.
  ///
  /// [Function] AppThemes().general().*
  /// has several derivative functions.
  ThemeData general() {
    final box = GetStorage();
    String tm = box.read(sThemeModeKey) ?? _sThemeModeLight;
    if (tm == _sThemeModeLight) {
      return _lightTheme;
    }
    return _darkTheme;
  }
}
