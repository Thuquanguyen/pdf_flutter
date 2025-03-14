import 'dart:io';

import 'package:booklibrary/data/local/1lib_repository.dart';
import 'package:booklibrary/data/local/favorite_repository.dart';
import 'package:booklibrary/data/local/recent_repository.dart';
import 'package:booklibrary/data/local/total_repository.dart';
import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:booklibrary/screens/app_controller.dart';
import 'package:booklibrary/screens/favorite/favorite_controller.dart';
import 'package:booklibrary/screens/home/home_controller.dart';
import 'package:booklibrary/screens/main/main_controller.dart';
import 'package:booklibrary/screens/recent/recent_controller.dart';
import 'package:booklibrary/utils/pdf_file_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalDbManager {
  static final LocalDbManager _singleton = LocalDbManager._internal();

  factory LocalDbManager() {
    return _singleton;
  }

  LocalDbManager._internal();

  FavoriteRepository favoriteRepository = FavoriteRepository();
  RecentRepository recentRepository = RecentRepository();
  OneLibRepository oneLibRepository = OneLibRepository();
  TotalRepository totalRepository = TotalRepository();

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PdfFileModelAdapter());
    await favoriteRepository.init();
    await recentRepository.init();
    await oneLibRepository.init();
    await totalRepository.init();
  }

  bool checkFileExits(String path) {
    if (File(path).existsSync()) {
      return true;
    }
    return false;
  }

  Future<List<PdfFileModel>> getFavoritePdfList() async {
    List<PdfFileModel> result = [];
    var response = await favoriteRepository.getListFavorite();
    for (int i = 0; i < response.length; i++) {
      if (checkFileExits(response[i].path ?? '')) {
        PdfFileModel fileModel = response[i];
        fileModel.isFavorite = true;

        PdfFileModel? tmp = PdfManager().pdfList.firstWhere(
            (element) => element.path == fileModel.path,
            orElse: () => PdfFileModel());
        fileModel.byteDataThumb = tmp.byteDataThumb;

        result.add(fileModel);
      }
    }
    AppController().find<MainController>()?.favoriteLength = result.length;
    return result;
  }

  Future<void> reloadData(List<PdfFileModel> dataList) async {
    AppController().find<FavoriteController>()?.loadData();
    AppController().find<RecentController>()?.loadData();
    AppController().find<HomeController>()?.updatePdfFile(dataList);
  }

  Future<void> addFavorite(PdfFileModel fileModel,
      {bool? reload = true}) async {
    fileModel.isFavorite = true;
    await favoriteRepository.addFavorite(fileModel);

    if (reload == true) {
      reloadData([fileModel]);
    }
  }

  Future<void> removeFavorite(PdfFileModel fileModel,
      {bool? reload = true}) async {
    fileModel.isFavorite = false;
    await favoriteRepository.removeFavorite(fileModel);

    if (reload == true) {
      reloadData([fileModel]);
    }
  }

  Future<void> getAllPdfLocalDb() async {
    PdfManager().pdfList = await totalRepository.getListTotal();
  }

  Future<List<PdfFileModel>> getRecentPdfList() async {
    List<PdfFileModel> result = [];

    var response = await recentRepository.getListRecent();
    for (int i = 0; i < response.length; i++) {
      if (checkFileExits(response[i].path ?? '')) {
        PdfFileModel fileModel = response[i];

        PdfFileModel tmp = PdfManager().pdfList.firstWhere(
            (element) => element.path == fileModel.path,
            orElse: () => PdfFileModel());
        fileModel.byteDataThumb = tmp.byteDataThumb;

        result.add(fileModel);
      }
    }

    AppController().find<MainController>()?.recentLength = result.length;

    return result;
  }

  Future<void> addRecent(PdfFileModel fileModel, {bool? reload = true}) async {
    print('addRecent');
    await recentRepository.addRecent(fileModel);

    if (reload == true) {
      reloadData([fileModel]);
    }
  }

  Future<void> removeRecent(PdfFileModel fileModel,
      {bool? reload = true}) async {
    fileModel.progress = 0;
    fileModel.currentPage = 0;
    await recentRepository.removeRecent(fileModel);

    if (reload == true) {
      reloadData([fileModel]);
    }
  }
}
