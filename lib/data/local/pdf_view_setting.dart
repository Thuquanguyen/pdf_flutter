import 'package:booklibrary/enum/display_type.dart';
import 'package:booklibrary/screens/detail/detail_controller.dart';
import 'package:get_storage/get_storage.dart';

class PdfViewSetting {
  static final PdfViewSetting _singleton = PdfViewSetting._internal();

  factory PdfViewSetting() {
    return _singleton;
  }

  PdfViewSetting._internal();

  var box = GetStorage();

  static const String _viewModeKey = '_viewModeKey';
  static const String _snapPageKey = '_snapPageKey';
  static const String _listDisplayType = '_listDisplayType';

  ViewMode? viewMode;
  bool? snapPage;

  DisplayType? listDisplayType;

  void loadData() {
    getViewMode();
    getSnapPage();
    getViewDisplayType();
  }

  void setViewDisplayType(DisplayType displayType) {
    listDisplayType = displayType;

    box.write(_listDisplayType, displayType.getColumn());
  }

  void getViewDisplayType() {
    int column = box.read(_listDisplayType) ?? 1;
    switch (column) {
      case 1:
        listDisplayType = DisplayType.list;
        break;
      case 2:
        listDisplayType = DisplayType.grid2;
        break;
      case 3:
        listDisplayType = DisplayType.grid3;
        break;
      case 4:
        listDisplayType = DisplayType.grid4;
        break;
      default:
        listDisplayType = DisplayType.list;
    }

    print('XXXXXXXXXXXXXXXXX $listDisplayType');
  }

  void setViewMode(ViewMode viewMode) {
    this.viewMode = viewMode;
    box.write(_viewModeKey, viewMode.getName());
  }

  void getViewMode() {
    String name = box.read(_viewModeKey) ?? '';
    if (name == ViewMode.horizontal.getName()) {
      viewMode = ViewMode.horizontal;
    } else {
      viewMode = ViewMode.vertical;
    }
  }

  void setSnapPage(bool value) {
    snapPage = value;
    box.write(_snapPageKey, value);
  }

  void getSnapPage() {
    snapPage = box.read(_snapPageKey);
  }
}
