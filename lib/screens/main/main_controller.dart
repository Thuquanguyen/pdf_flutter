import 'dart:io';

import 'package:booklibrary/constants.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/app_functions.dart';
import 'package:booklibrary/core/app_translations.dart';
import 'package:booklibrary/core/local_storage/localStorageHelper.dart';
import 'package:booklibrary/data/local/favorite_repository.dart';
import 'package:booklibrary/model/base_model.dart';
import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:booklibrary/screens/app_controller.dart';
import 'package:booklibrary/screens/detail/detail_screen.dart';
import 'package:booklibrary/screens/multile_file_selected/multile_file_selected_screen.dart';
import 'package:booklibrary/screens/qr_code/qr_code_controller.dart';
import 'package:booklibrary/screens/recent/recent_controller.dart';
import 'package:booklibrary/screens/search/search_controller.dart';
import 'package:booklibrary/screens/selected_controller.dart';
import 'package:booklibrary/screens/splash/language_controller.dart';
import 'package:booklibrary/screens/widget/dialog_confirm.dart';
import 'package:booklibrary/screens/widget/view_review.dart';
import 'package:booklibrary/utils/message_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/local/local_db_manager.dart';
import '../../utils/pdf_file_manager.dart';
import '../favorite/favorite_controller.dart';
import '../home/home_controller.dart';

class MainController extends GetxController {
  Rx<int> id = 0.obs;

  //Tổng Số lượng file
  Rx<int> totalFile = 0.obs;

  Rx<int> selectedIndex = 0.obs;
  Rx<int> selectedFile = 0.obs;
  Rx<String> title = I18n().allFileStr.tr.obs;

  int recentLength = 0;
  int favoriteLength = 0;

  List<PdfFileModel> pdfList = [];

  //Dùng cho màn chọn nhiều file
  Rx<PageType?> selectedPageType = PageType.none.obs;

  // HomeController? _homeController;
  // RecentController? _recentController;
  // FavoriteController? _favoriteController;
  void setSelectedFile(int value) {
    selectedFile.value = value;
  }

  void setPageType(PageType? type) {
    selectedPageType.value = type;
    if (type == PageType.home) {
      pdfList = AppController().find<HomeController>()?.pdfList ?? [];
    } else if (type == PageType.recent) {
      pdfList = AppController().find<RecentController>()?.pdfList ?? [];
    } else if (type == PageType.search) {
      pdfList = AppController().find<SearchController>()?.pdfList ?? [];
    } else if (type == PageType.favorite) {
      pdfList = AppController().find<FavoriteController>()?.pdfList ?? [];
    } else {
      pdfList = [];
    }
  }

  //lấy tổng sl file
  void getTotalFile() {
    int length = PdfManager().pdfList.length;
    if (selectedIndex.value == 0) {
      length = PdfManager().pdfList.length;
    } else if (selectedIndex.value == 1) {
      length = recentLength;
    } else if (selectedIndex.value == 4) {
      length = favoriteLength;
    }
    totalFile.value = length;
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return I18n().allFileStr.tr;
      case 1:
        return I18n().recentStr.tr;
      case 2:
        return '';
      case 3:
        return I18n().searchStr.tr;
      case 4:
        return I18n().favoriteStr.tr;
    }
    return I18n().allFileStr.tr;
  }

  void changePage(int index) {
    if(index == 2 || index == 3){
      return;
    }
    selectedIndex.value = index;
    title.value = getTitle(index);
    getTotalFile();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    checkLanguage();
    super.onInit();
    AppController().initController<MainController>(this);
    MessageHandler().register(OPEN_RATE_APP, showRateApp);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    MessageHandler().unregister(OPEN_RATE_APP);
    super.dispose();
  }

  void showRateApp(dynamic data) async {
    bool? isShowRate = await LocalStorageHelper.getBool(OPEN_RATE_APP);
    String? dateCurrent = await LocalStorageHelper.getString(KEY_DATE_TIME);
    bool isCheckDate = false;
    if (dateCurrent != null) {
      print("dateCurrent = $dateCurrent");
      isCheckDate = AppFunc.checkDateTime(dateCurrent);
    }
    if (isShowRate == null || isCheckDate) {
      await LocalStorageHelper.setBool(OPEN_RATE_APP, true);
      await LocalStorageHelper.setString(
          KEY_DATE_TIME, AppFunc.getTimeNowString());
      Get.bottomSheet(const ViewReview(),
          isScrollControlled: true,
          isDismissible: false,
          ignoreSafeArea: false,
          useRootNavigator: true);
    }
  }

  void checkLanguage() {
    resetLanguage();
    List<BaseModel> _listLanguages = LanguageController().listLanguages;
    int index = 0;
    for (int i = 0; i < _listLanguages.length; i++) {
      if (_listLanguages[i].key?.contains(AppTranslations.localeStr) ?? false) {
        index = i;
        _listLanguages[i].selected = true;
      }
    }
    if (index < LanguageController().listLanguages.length) {
      id.value = LanguageController().listLanguages[index].id ?? 0;
    }
  }

  void resetLanguage() {
    for (var element in LanguageController().listLanguages) {
      element.selected = false;
    }
  }

  void changeLanguage(int id) {
    resetSelect(id);
    this.id.value = LanguageController().listLanguages[id].id ?? 0;
    AppTranslations.updateLocale(
        langCode: (LanguageController().listLanguages[id].key?.split('_')[0]) ??
            'en');
    title.value = getTitle(selectedIndex.value);
    Get.rootController.reactive;
  }

  void resetSelect(int index) {
    for (int i = 0; i < LanguageController().listLanguages.length; i++) {
      LanguageController().listLanguages[i].selected = false;
    }
    if (index < LanguageController().listLanguages.length) {
      LanguageController().listLanguages[index].selected = true;
    }
  }

  void sendContact() {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@1pdf.app',
      query: encodeQueryParameters(<String, String>{'subject': ''}),
    );

    launchUrl(emailLaunchUri);
  }

  void pickerFile() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Permission _permission;
    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int? version = androidInfo.version.sdkInt ?? 30;

      if (version >= 30) {
        _permission = Permission.manageExternalStorage;
      } else {
        _permission = Permission.storage;
      }
    }else{
      _permission = Permission.storage;
    }
    if (await _permission.request().isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      String fileChecksum = '';
      String path = result?.files.first.path ?? '';
      fileChecksum = await AppFunc.generateMd5(path);
      PdfFileModel pdfFileModel = getModel(fileChecksum);
      if (pdfFileModel.path?.isNotEmpty == true) {
        _gotoDetailScreen(pdfFileModel);
      }
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [_permission].request();
      if (statuses[_permission] == PermissionStatus.granted) {
        pickerFile();
      }
    }
  }

  PdfFileModel getModel(String md5) {
    List<PdfFileModel> _listFile = PdfManager().pdfList;
    for (int i = 0; i < _listFile.length; i++) {
      if (_listFile[i].md5 == md5) {
        return _listFile[i];
      }
    }
    return PdfFileModel();
  }

  Future<void> _gotoDetailScreen(PdfFileModel pdfFileModel) async {
    //Lưu vào db recent
    await Get.toNamed(
      DetailScreen.routeName,
      arguments: pdfFileModel,
    );

    // Future.delayed(const Duration(milliseconds: 500), () {
    //   onBackFromDetailScreen?.call();
    // });
  }

  Future<void> deleteFile() async {
    Get.dialog(
      DialogConfirmWidget(
        callBack: () async {
          for (var element in pdfList) {
            if (element.isSelected == true) {
              await PdfManager().deleteFile(element);
              PdfManager()
                  .pdfList
                  .removeWhere((pdf) => pdf.path == element.path);
            }
          }
          showDialog();

          AppController().find<RecentController>()?.loadData();
          AppController().find<FavoriteController>()?.loadData();
          AppController().find<HomeController>()?.loadData();
        },
      ),
    );
  }

  void showDialog() {
    Get.dialog(
      const Align(
        child: Center(
          child: CircularProgressIndicator(color: Color(0xff536A92)),
        ),
      ),
    );
    Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        removeSelected();
      },
    );
  }

  void removeRecent() {
    for (var element in pdfList) {
      if (element.isSelected == true) {
        LocalDbManager().removeRecent(element, reload: false);
      }
    }
    LocalDbManager().reloadData(pdfList);
    showDialog();
  }

  Future<void> addFavorite() async {
    Map<String, PdfFileModel> data = {};
    for (var element in pdfList) {
      if (element.isSelected == true) {
        element.isFavorite = true;
        // LocalDbManager().addFavorite(element, reload: false);
        data[element.path ?? ''] = element;
      }
    }

    await FavoriteRepository().addMultipleFavorite(data);
    LocalDbManager().reloadData(pdfList);
    showDialog();
  }

  Future<void> removeFavorite() async {
    List<String> data = [];
    for (var element in pdfList) {
      if (element.isSelected == true) {
        element.isFavorite = false;
        // LocalDbManager().removeFavorite(element, reload: false);
        data.add(element.path ?? '');
      }
    }

    await FavoriteRepository().removeMultipleFavorite(data);
    LocalDbManager().reloadData(pdfList);
    showDialog();
  }

  void share() {
    List<String> path = [];
    for (var element in pdfList) {
      if (element.isSelected == true) {
        path.add(element.path ?? '');
      }
    }
    if (path.isNotEmpty) {
      Share.shareFiles(
        path,
      );
    }
  }

  void shareApplication() {
    Share.share(
        'https://play.google.com/store/apps/details?id=app.digitalcontent.onepdf',
        subject: I18n().downloadAppStr.tr);
  }

  SelectedController? getCurrentPageController() {
    if (selectedIndex.value == PageType.home.getIndex()) {
      return AppController().find<HomeController>();
    } else if (selectedIndex.value == PageType.recent.getIndex()) {
      return AppController().find<RecentController>();
    } else {
      return AppController().find<FavoriteController>();
    }
  }

  void removeSelected() {
    SelectedController? currController = getCurrentPageController();
    currController?.removeSelected();
    setPageType(PageType.none);
  }

  void changeSelectedAll() {
    SelectedController? currController = getCurrentPageController();
    currController?.changeSelectedAll();
  }

  void increaseTotalFile() {
    totalFile.value = totalFile.value + 1;
  }
}
