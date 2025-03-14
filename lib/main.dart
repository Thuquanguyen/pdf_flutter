import 'package:booklibrary/core/app_dimens.dart';
import 'package:booklibrary/core/app_functions.dart';
import 'package:booklibrary/core/app_themes.dart';
import 'package:booklibrary/core/app_translations.dart';
import 'package:booklibrary/deeplink_utils.dart';
import 'package:booklibrary/routes/pages.dart';
import 'package:booklibrary/screens/main/main_binding.dart';
import 'package:booklibrary/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'data/local/local_db_manager.dart';
import 'screens/splash/splash_binding.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  // CustomImageCache();
  // Initialize Firebase.
  await Firebase.initializeApp();
  // await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);

  DeepLinkUtils().init();

  await GetStorage.init();
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('first_run') ?? true) {
    final box = GetStorage();
    box.remove(AppThemes().sThemeModeKey);
    prefs.setBool('first_run', false);
  }

  await LocalDbManager().init();
  AppFunc.initHttpSslIgnore();
  MainBinding().dependencies();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    AppTranslations.init();
    AppFunc().initWeakLock();
    Wakelock.disable();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        theme: AppThemes.theme(),
        darkTheme: AppThemes.darkTheme(),
        themeMode: AppThemes().general() == AppThemes.darkTheme()
            ? ThemeMode.dark
            : ThemeMode.light,
        locale: AppTranslations.fallbackLocale,
        fallbackLocale: AppTranslations.fallbackLocale,
        translations: AppTranslations(),
        initialRoute: SplashScreen.routeName,
        initialBinding: SplashBinding(),
        debugShowCheckedModeBanner: false,
        getPages: Pages.pages(),
        builder: EasyLoading.init(builder: (context, child) {
          AppDimens.init(context);
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child ?? const SizedBox());
        }),
      ),
    );
  }
}
