import 'package:booklibrary/core/app_core.dart';
import 'package:get/get.dart';

enum SortBy { modify, name, size }
enum SortByType { up, down }

extension SortByExt on SortBy {
  String getSortDownTitle() {
    switch (this) {
      case SortBy.modify:
        return I18n().fromNewToOldStr.tr;
      case SortBy.name:
        return 'A-Z';
      case SortBy.size:
        return I18n().fromLargeToSmallSizeStr.tr;
      default:
        return '';
    }
  }

  String getSortUpTitle() {
    switch (this) {
      case SortBy.modify:
        return I18n().fromOldToNewStr.tr;
      case SortBy.name:
        return 'Z-A';
      case SortBy.size:
        return I18n().fromSmallToLargeSizeStr.tr;
      default:
        return '';
    }
  }

  String getTitle() {
    switch (this) {
      case SortBy.modify:
        return I18n().sortByLastModifiedStr.tr;
      case SortBy.name:
        return I18n().sortByNameStr.tr;
      case SortBy.size:
        return I18n().sortBySizeStr.tr;
      default:
        return '';
    }
  }
}
