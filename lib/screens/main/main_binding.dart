import 'package:booklibrary/screens/favorite/favorite_controller.dart';
import 'package:booklibrary/screens/home/home_controller.dart';
import 'package:booklibrary/screens/qr_code/qr_code_controller.dart';
import 'package:booklibrary/screens/qr_code/qr_code_screen.dart';
import 'package:booklibrary/screens/recent/recent_controller.dart';
import 'package:booklibrary/screens/search/search_controller.dart';
import 'package:booklibrary/screens/search/search_screen.dart';
import 'package:get/get.dart';

import 'main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => RecentController());
    Get.lazyPut(() => FavoriteController());
    Get.lazyPut(() => QrCodeController());
    Get.lazyPut(() => SearchController());
  }
}
