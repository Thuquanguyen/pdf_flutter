import 'dart:io';

import 'package:booklibrary/language/en_US.dart';
import 'package:booklibrary/language/vi_VN.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app_config.dart';

class AppTranslations extends Translations {
  // Default locale
  static final locale = Locale('vi');

  // fallbackLocale saves the day when the locale gets in trouble
  static final fallbackLocale = Locale('en');

  static String localeStr = 'vi';

  static void init() {
    final box = GetStorage();
    localeStr = box.read(AppConfig.LANGUAGE) ?? 'en';
    print('localeStr = $localeStr');
    if (localeStr == null) {
      String lang = Platform.localeName;
      Get.updateLocale(Locale(lang.split('_')[0].isNotEmpty ? lang.split('_')[0] : 'en'));
      box.write(AppConfig.LANGUAGE, lang.split('_')[0].isNotEmpty ? lang.split('_')[0] : 'en');
    } else {
      Get.updateLocale(Locale(localeStr));
    }
  }

  static void updateLocale({required String langCode}) {
    final box = GetStorage();
    Get.updateLocale(Locale(langCode));
    box.write(AppConfig.LANGUAGE, langCode);
  }

  void buildLanguage(String lang,Map<String, Map<String, String>> dataAll) {
    Map<String, Map<String, String>> dataAllNew = {};
    if(dataAll.containsKey(lang) && dataAll[lang] is Map<String, String>) {
      Map<String, String> data = dataAll[lang] as Map<String, String>; //ko rong lay ve tu api
      Map<String, String> newData = {...en_US, ...data};
      dataAllNew[lang] = newData;
    }
    addNewTranslate(dataAllNew);
  }

  void addNewTranslate(Map<String, Map<String, String>> data) {
    // data = {vi: {key: value}, en: {key: value, key1: value1}, id: {key: value}} // Map (String -> Map)
    Get.addTranslations(data);
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'vi': vi_VN,
        'en': en_US,
      };
}
