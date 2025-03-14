import 'package:booklibrary/data/local/pdf_view_setting.dart';
import 'package:booklibrary/enum/display_type.dart';
import 'package:booklibrary/enum/sort_by.dart';
import 'package:booklibrary/screens/app_controller.dart';
import 'package:booklibrary/screens/main/main_controller.dart';
import 'package:booklibrary/screens/recent/recent_controller.dart';
import 'package:booklibrary/screens/widget/dialog_confirm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../data/local/local_db_manager.dart';
import '../model/pdf_file_model.dart';
import '../utils/pdf_file_manager.dart';
import 'favorite/favorite_controller.dart';
import 'home/home_controller.dart';

class SelectedController extends GetxController {

  void insertPdfView(PdfFileModel pdfFileModel) {
    if (_pdfList.isNotEmpty) {
      _pdfList.value.insert(0, pdfFileModel);
    } else {
      _pdfList.value.add(pdfFileModel);
    }
    AppController().find<MainController>()?.increaseTotalFile();
  }

  void setData(List<PdfFileModel> value) {
    _pdfList.value = value;
  }

  final RxList<PdfFileModel> _pdfList = RxList();

  List<PdfFileModel> get pdfList => _pdfList.toList();

  RxBool selectedScreen = false.obs;

  final Rx<SortBy> _sortBy = SortBy.modify.obs;

  SortBy? get sortBy => _sortBy.value;

  final Rx<SortByType> _sortByType = SortByType.down.obs;

  SortByType? get sortByType => _sortByType.value;

  final Rxn<DisplayType> _displayType = Rxn();

  DisplayType? get displayType => _displayType.value;

  void updateProgress(PdfFileModel pdfFileModel) {
    PdfFileModel fileModel = _pdfList
        .toList()
        .firstWhere((element) => (element.path == pdfFileModel.path));
    fileModel.progress = pdfFileModel.progress;
  }

  void changeDisplayType(DisplayType type) {
    _displayType.value = type;
    if (type != PdfViewSetting().listDisplayType) {
      PdfViewSetting().setViewDisplayType(type);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _displayType.value = PdfViewSetting().listDisplayType ?? DisplayType.list;
  }

  void selected(PdfFileModel pdf) {
    var data = <PdfFileModel>[];
    data.addAll(pdfList);

    _pdfList.value = pdfList;

    int count = 0;
    for (var element in pdfList) {
      if (element.isSelected == true) {
        count++;
      }
    }
    AppController().find<MainController>()?.setSelectedFile(count);
  }

  void deleteMultipleFile() {
    Get.dialog(
      DialogConfirmWidget(
        callBack: () async {
          for (var element in pdfList) {
            if (element.isSelected == true) {
              PdfManager().deleteFile(element);
            }
          }
          showDialog();

          Get.find<RecentController>().loadData();
          Get.find<FavoriteController>().loadData();
          Get.find<HomeController>().loadData();
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
        Get.back(result: true);
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

  void addFavorite() {
    for (var element in pdfList) {
      if (element.isSelected == true) {
        LocalDbManager().addFavorite(element, reload: false);
      }
    }
    LocalDbManager().reloadData(pdfList);
    showDialog();
  }

  void removeFavorite() {
    for (var element in pdfList) {
      if (element.isSelected == true) {
        LocalDbManager().removeFavorite(element, reload: false);
      }
    }
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

  void removeSelected() {
    selectedScreen.value = false;
    _pdfList.toList().forEach((element) {
      element.isSelected = false;
    });
  }

  bool isSelectedAll = false;

  void changeSelectedAll() {
    isSelectedAll = !isSelectedAll;

    List<PdfFileModel> data = [];
    for (var element in pdfList) {
      element.isSelected = isSelectedAll;
      data.add(element);
    }
    int selectedCount;
    if (isSelectedAll) {
      selectedCount = data.length;
    } else {
      selectedCount = 0;
    }
    AppController().find<MainController>()?.setSelectedFile(selectedCount);

    _pdfList.value = data;
  }

  void deleteFile(PdfFileModel pdf) {
    var data = <PdfFileModel>[];
    data.addAll(pdfList);
    data.removeWhere((item) => item.path == pdf.path);

    _pdfList.value = data;
  }

  void setSortType(SortBy? sortBy, SortByType? sortByType,
      {List<PdfFileModel>? dataList}) {
    sortBy = sortBy ?? SortBy.modify;
    sortByType = sortByType ?? SortByType.up;

    _sortBy.value = sortBy;
    _sortByType.value = sortByType;

    int tmp = 1;
    if (sortByType == SortByType.up) {
      tmp = -1;
    } else {
      tmp = 1;
    }

    var data = <PdfFileModel>[];
    data.addAll(dataList ?? pdfList);

    if (sortBy == SortBy.modify) {
      data.sort((a, b) {
        if (a.modifyDate != null && b.modifyDate != null) {
          return a.modifyDate!.compareTo(b.modifyDate!) * tmp * -1;
        }
        return 0;
      });
    } else if (sortBy == SortBy.name) {
      data.sort((a, b) {
        if (a.name != null && b.name != null) {
          return a.name!.compareTo(b.name!) * tmp;
        }
        return 0;
      });
    } else if (sortBy == SortBy.size) {
      data.sort((a, b) {
        return (((a.size ?? 0) - (b.size ?? 0)) * tmp) > 0 ? -1 : 1;
      });
    }

    setData(data);
  }
}
