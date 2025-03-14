import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class FavoriteRepository {
  final String name = 'favoriteBox';
  late Box<PdfFileModel> favoriteBox;

  static final FavoriteRepository _singleton = FavoriteRepository._internal();

  factory FavoriteRepository() {
    return _singleton;
  }

  FavoriteRepository._internal();

  Future<void> init() async {
    favoriteBox = await Hive.openBox<PdfFileModel>(name);
  }

  Future<void> addFavorite(PdfFileModel data) async {
    if (favoriteBox.containsKey(data.path)) {
      return;
    }
    return favoriteBox.put(data.path, data);
  }

  Future<void> removeFavorite(PdfFileModel data) async {
    print('removeFavorite');
    if (data.path == null) {
      return;
    }
    return favoriteBox.delete(data.path);
  }

  Future<void> addMultipleFavorite(Map<String, PdfFileModel> data) async {
    return favoriteBox.putAll(data);
  }

  Future<void> removeMultipleFavorite(List<String> data) async {
    return favoriteBox.deleteAll(data);
  }

  Future<List<PdfFileModel>> getListFavorite() async {
    return favoriteBox.values.toList();
  }
}
