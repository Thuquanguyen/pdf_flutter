import 'dart:convert';
import 'dart:io';

import 'package:booklibrary/constants.dart';
import 'package:booklibrary/model/base_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/api_service/api_provider.dart';
import '../../core/app_config.dart';
import '../../core/app_translations.dart';

class DemoController extends GetxController {
  RxList<BaseModel> listLanguages = <BaseModel>[].obs;
  Rx<int> id = 0.obs;
  late final ApiProviderRepositoryImpl apiProvider;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    apiProvider = ApiProviderRepositoryImpl();
    getKeyLanguageLocal();
    getDataLanguageLocal();
    super.onInit();
  }

  void getKeyLanguage() async {
    await apiProvider
        .getRequest(PATH_GET_KEY_LANGUAGE)
        .then((value) => saveKeyLanguage(jsonEncode(value.data)));
  }

  void saveKeyLanguage(String data) {
    final box = GetStorage();
    box.write(AppConfig.KEY_LANGUAGE, data);
    getKeyLanguageLocal();
  }

  void saveDataLanguage(String data) {
    final box = GetStorage();
    box.write(AppConfig.DATA_LANGUAGE, data);
    getDataLanguageLocal();
  }

  void getKeyLanguageLocal() {
    final box = GetStorage();
    if (box.read(AppConfig.KEY_LANGUAGE) == null) {
      getKeyLanguage();
      return;
    }
    Map<String, dynamic> data = jsonDecode(box.read(AppConfig.KEY_LANGUAGE));
    int index = 0;
    data.forEach((key, value) {
      listLanguages.value.add(
          BaseModel(id: index, title: value, selected: index == 0, key: key));
      index += 1;
    });
    initLanguage();
    refresh();
  }

  initLanguage() async {
    if (listLanguages.isEmpty) {
      return;
    }
    id.value = listLanguages.value[0].id ?? -1;
  }

  void getDataLanguageLocal() {
    final box = GetStorage();
    if (box.read(AppConfig.DATA_LANGUAGE) == null) {
      getDetailLanguage();
      return;
    }
    Map<String, dynamic> data = jsonDecode(box.read(AppConfig.DATA_LANGUAGE));
    Map<String, Map<String,String>> language = {};
    data.forEach((key, value) {
      String lang = key.split('_')[0];
      Map<String, String> dataLanguage = Map<String,String>.from(value);
      language.addAll({lang : dataLanguage});
    });
    language.forEach((key, value) {
      AppTranslations().buildLanguage(key, language);
    });
    // set language and add language
  }

  void getDetailLanguage() async {
    await apiProvider
        .getRequest(PATH_GET_LANGUAGE)
        .then((value) => saveDataLanguage(jsonEncode(value.data)));
  }

  void changeLanguage(int id) {
    resetSelect(id);
    this.id.value = listLanguages.value[id].id ?? 0;
    AppTranslations.updateLocale(
        langCode: (listLanguages.value[id].key?.split('_')[0]) ?? 'en');
    Get.rootController.reactive;
  }

  void resetSelect(int index) {
    for (int i = 0; i < listLanguages.value.length; i++) {
      listLanguages.value[i].selected = false;
    }
    if (index < listLanguages.length) {
      listLanguages.value[index].selected = true;
    }
  }

}
