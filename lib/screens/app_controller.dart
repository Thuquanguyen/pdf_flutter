import 'package:booklibrary/screens/favorite/favorite_controller.dart';
import 'package:booklibrary/screens/home/home_controller.dart';
import 'package:booklibrary/screens/main/main_controller.dart';
import 'package:booklibrary/screens/recent/recent_controller.dart';
import 'package:get/get.dart';

class AppController {
  static final AppController _singleton = AppController._internal();

  factory AppController() {
    return _singleton;
  }

  AppController._internal();

  MainController? _mainController;
  HomeController? _homeController;
  RecentController? _recentController;
  FavoriteController? _favoriteController;

  void initController<T>(T controller) {
    if (controller is HomeController) {
      _homeController = controller;
    }
    if (controller is FavoriteController) {
      _favoriteController = controller;
    }
    if (controller is RecentController) {
      _recentController = controller;
    }
    if (controller is MainController) {
      _mainController = controller;
    }
  }

  T? find<T>() {
    if (T.toString().compareTo('MainController') == 0) {
      _mainController ??= Get.find();
      return _mainController as T;
    }
    if (T.toString().compareTo('RecentController') == 0) {
      _recentController ??= Get.find();
      return _recentController as T;
    }
    if (T.toString().compareTo('HomeController') == 0) {
      _homeController ??= Get.find();
      return _homeController as T;
    }
    if (T.toString().compareTo('FavoriteController') == 0) {
      _favoriteController ??= Get.find();
      return _favoriteController as T;
    }
    return null;
  }
}
