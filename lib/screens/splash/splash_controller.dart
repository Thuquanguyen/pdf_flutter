import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:booklibrary/constants.dart';
import 'package:booklibrary/core/api_service/api_provider.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/app_functions.dart';
import 'package:booklibrary/core/app_translations.dart';
import 'package:booklibrary/data/local/local_db_manager.dart';
import 'package:booklibrary/model/base_model.dart';
import 'package:booklibrary/screens/main/main_screen.dart';
import 'package:booklibrary/screens/splash/language_controller.dart';
import 'package:booklibrary/utils/message_handler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/local/pdf_view_setting.dart';
import '../../utils/pdf_file_manager.dart';

class SplashController extends GetxController {
  Rx<int> id = 0.obs;
  Rx<bool> isSetting = false.obs;
  Rx<bool> isShowLoading = true.obs;
  RxList<BaseModel> listLanguages = <BaseModel>[].obs;
  late final ApiProviderRepositoryImpl apiProvider;
  bool isLoadedDocument = false;
  bool isGoToHome = false;
  Rx<String> loadingMsg = 'loading'.obs;
  Rx<String> filePath = ''.obs;
  Rx<int> progressFile = 0.obs;

  Future<void> init() async {
    loadingMsg.value = 'get_file';
    refresh();
    initMessage();
    MessageHandler().register(START_SCAN, handleScan);
    if(Platform.isAndroid){
      await PdfManager().getAllPdf();
    }else{
      await PdfManager().loadFromDeviceInBackground();
    }
    if(Platform.isAndroid) {
      progressFile.value = 100;
    }
    //check first time load
    await Future.delayed(const Duration(milliseconds: 100));
    apiProvider = ApiProviderRepositoryImpl();
    PdfManager().checkPermission();
    PdfViewSetting().loadData();
    filePath.value = '';
    loadingMsg.value = 'init_lang';
    refresh();
    checkLanguage();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    AppFunc.setTimeout(() {
      init();
    }, 2000);
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    MessageHandler().unregister(GET_PATH_FILE);
    MessageHandler().unregister(START_SCAN);
    super.dispose();
  }

  void changeProgress() async {
    var rng = Random();
    while (true) {
      print('progressFile.value = ${progressFile.value}');
      if (progressFile.value >= 99) {
        return;
      } else {
        int newProgress = progressFile.value + rng.nextInt(5);
        if (newProgress >= 99) newProgress = 99;
        progressFile.value = newProgress;
      }
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  void initMessage() {
    final box = GetStorage();
    dynamic isFirstSetting = box.read(AppConfig.KEY_LANGUAGE);
    if (isFirstSetting == null) {
      MessageHandler().register(GET_PATH_FILE, handlePath);
    } else {
      filePath.value = '';
    }
  }

  void handlePath(dynamic path) {
    filePath.value = path as String;
    refresh();
  }

  void handleScan(dynamic value) {
    changeProgress();
  }

  void checkLanguage() {
    final box = GetStorage();
    if (box.read(AppConfig.KEY_LANGUAGE) != null) {
      getKeyLanguageLocal();
      getDataLanguageLocal();
    } else {
      getKeyLanguage();
      getDetailLanguage();
    }
  }

  void getKeyLanguage() async {
    await apiProvider.getRequest(PATH_GET_KEY_LANGUAGE).catchError((err) {
      goToMain();
    }).then((value) {
      saveKeyLanguage(jsonEncode(value.data));
    });
  }

  void saveKeyLanguage(String data) {
    final box = GetStorage();
    box.write(AppConfig.KEY_LANGUAGE, data);
    getKeyLanguageLocal();
  }

  void saveDataLanguage(String data) {
    final box = GetStorage();
    box.write(AppConfig.DATA_LANGUAGE, data);
    isShowLoading.value = false;
    getDataLanguageLocal();
  }

  void getKeyLanguageLocal() {
    LanguageController().listLanguages.clear();
    final box = GetStorage();
    Map<String, dynamic> data = jsonDecode(box.read(AppConfig.KEY_LANGUAGE));
    int index = 0;
    data.forEach((key, value) {
      listLanguages.value.add(
          BaseModel(id: index, title: value, selected: index == 0, key: key));
      index += 1;
    });
    LanguageController().listLanguages = listLanguages.value;
    refresh();
    update();
  }

  void getDataLanguageLocal() {
    final box = GetStorage();
    Map<String, dynamic> data = jsonDecode(box.read(AppConfig.DATA_LANGUAGE));
    Map<String, Map<String, String>> language = {};
    data.forEach((key, value) {
      String lang = key.split('_')[0];
      Map<String, String> dataLanguage = Map<String, String>.from(value);
      language.addAll({lang: dataLanguage});
    });
    language.forEach((key, value) {
      AppTranslations().buildLanguage(key, language);
    });
    initLanguage();
    // set language and add language
  }

  void getDetailLanguage() async {
    await apiProvider.getRequest(PATH_GET_LANGUAGE).catchError((err) {
      goToMain();
    }).then((value) => saveDataLanguage(jsonEncode(value.data)));
  }

  initLanguage() async {
    if (listLanguages.isEmpty) {
      return;
    }
    id.value = listLanguages.value[0].id ?? -1;
    checkSetting();
  }

  checkSetting() async {
    isShowLoading.value = false;
    final box = GetStorage();
    dynamic isFirstSetting = box.read(AppConfig.FIRST_SETTING_LANGUAGE);
    if (isFirstSetting == null) {
      setLanguageDefault();
      isSetting.value = true;
    } else {
      AppTranslations.init();
      isSetting.value = false;
      goToMain();
    }
  }

  void setLanguageDefault() {
    String lang = Platform.localeName;
    int index = 0;
    listLanguages.value.forEach((element) {
      if (element.key?.contains(lang) ?? false) {
        index += 1;
        id.value = element.id ?? 0;
        AppTranslations.updateLocale(langCode: (lang));
        Get.rootController.reactive;
      }
    });
    if (index == 0) {
      AppTranslations.updateLocale(langCode: ('en'));
      Get.rootController.reactive;
    }
  }

  goToMain() {
    if (!isGoToHome) {
      isGoToHome = true;
      Get.offAllNamed(MainScreen.routeName);
    }
  }

  void actionNext() {
    final box = GetStorage();
    box.write(AppConfig.FIRST_SETTING_LANGUAGE, true);
    print("listvalue = ${listLanguages.value[id.value].key?.split('_')[0]}");
    if(id.value < listLanguages.value.length){
      AppTranslations.updateLocale(
          langCode: (listLanguages.value[id.value].key?.split('_')[0]) ?? 'en');
      AppTranslations.localeStr = (listLanguages.value[id.value].key?.split('_')[0]) ?? 'en';
    }
    Get.rootController.reactive;
    goToMain();
  }

  void changeLanguage(int id) {
    resetSelect(id);
    int id1 = listLanguages.value[id].id ?? 0;
    this.id.value = id1;
    AppTranslations.updateLocale(
        langCode: (listLanguages.value[id].key?.split('_')[0]) ?? 'en');
    Get.rootController.reactive;
  }

  void resetSelect(int index) {
    // LanguageController().listLanguages.clear();
    for (int i = 0; i < listLanguages.value.length; i++) {
      listLanguages.value[i].selected = false;
    }
    if (index < listLanguages.length) {
      listLanguages.value[index].selected = true;
    }
    LanguageController().listLanguages = listLanguages.value;
    AppTranslations.updateLocale(
        langCode: listLanguages.value[index].key ?? 'en');
  }
}
