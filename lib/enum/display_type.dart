import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/app_translations.dart';
import 'package:get/get.dart';

enum DisplayType { list, grid2, grid3, grid4 }

extension DisplayTypeExt on DisplayType {
  int getColumn() {
    switch (this) {
      case DisplayType.list:
        return 1;
      case DisplayType.grid2:
        return 2;
      case DisplayType.grid3:
        return 3;
      case DisplayType.grid4:
        return 4;
      default:
        return 1;
    }
  }

  String getName() {
    switch (this) {
      case DisplayType.grid2:
        return '2 ${I18n().columnStr.tr}';
      case DisplayType.grid3:
        return '3 ${I18n().columnStr.tr}';
      case DisplayType.grid4:
        return '4 ${I18n().columnStr.tr}';
      default:
        return '';
    }
  }
}
