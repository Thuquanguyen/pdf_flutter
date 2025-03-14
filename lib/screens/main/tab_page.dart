
// ignore: constant_identifier_names
import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/language/i18n.g.dart';
import 'package:get/get.dart';

enum TabPage { ALL_FILES, RECENT, FAVORITE, QRSCAN, SEARCH}

extension TabPageIndex on TabPage {
  int get tabIndex {
    switch (this) {
      case TabPage.ALL_FILES:
        return 0;
      case TabPage.RECENT:
        return 1;
      case TabPage.QRSCAN:
        return 2;
      case TabPage.SEARCH:
        return 3;
      case TabPage.FAVORITE:
        return 4;
    }
    return -1;
  }
}

// ignore: constant_identifier_names
final List<Map<String, Object>> TABS = [
  {
    'title': I18n().allFileStr,
    'icon': AppAssets.icAllFile,
    'page': TabPage.ALL_FILES,
  },
  {
    'title': I18n().recentStr,
    'icon': AppAssets.icRecent,
    'page': TabPage.RECENT,
  },
  {
    'title': '',
    'icon': AppAssets.icQrScanBottom,
    'page': TabPage.QRSCAN,
  },
  {
    'title': I18n().searchStr,
    'icon': AppAssets.icSearch,
    'page': TabPage.SEARCH,
  },
  {
    'title': I18n().favoriteStr,
    'icon': AppAssets.icFavorite,
    'page': TabPage.FAVORITE,
  },
];
