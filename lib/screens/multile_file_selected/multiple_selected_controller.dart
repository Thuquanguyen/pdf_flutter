import 'package:booklibrary/data/local/local_db_manager.dart';
import 'package:booklibrary/screens/favorite/favorite_controller.dart';
import 'package:booklibrary/screens/home/home_controller.dart';
import 'package:booklibrary/screens/multile_file_selected/multile_file_selected_screen.dart';
import 'package:booklibrary/screens/recent/recent_controller.dart';
import 'package:booklibrary/screens/widget/dialog_confirm.dart';
import 'package:booklibrary/utils/pdf_file_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../enum/display_type.dart';
import '../../enum/sort_by.dart';
import '../../model/pdf_file_model.dart';

class MultipleSelectedController extends GetxController {
  static String argPageType = 'pageType';
  static String argSelectedPdf = 'selectedPdf';
  static String argSortBy = 'sortBy';
  static String argSortByType = 'sortByType';
  static String argDisplayType = 'displayType';
  static String argListData = 'listData';

  PageType? pageType;
  int? totalFile;
  RxInt selectedCount = 1.obs;

  final Rx<SortBy> _sortBy = SortBy.modify.obs;

  SortBy? get sortBy => _sortBy.value;

  final Rx<SortByType> _sortByType = SortByType.down.obs;

  SortByType? get sortByType => _sortByType.value;

  final Rxn<DisplayType> _displayType = Rxn();

  DisplayType? get displayType => _displayType.value;

  final RxList<PdfFileModel> _pdfList = RxList();

  List<PdfFileModel> get pdfList => _pdfList.toList();

  final RxList<PdfFileModel> _selectedPdfList = RxList();

  List<PdfFileModel> get selectedPdfList => _selectedPdfList.toList();

  bool isSelectedAll = false;

  @override
  void onInit() {
    super.onInit();
    pageType = Get.arguments[argPageType];
    _sortBy.value = Get.arguments[argSortBy];
    _sortByType.value = Get.arguments[argSortByType];
    _displayType.value = Get.arguments[argDisplayType];
    PdfFileModel pdfFileModel = Get.arguments[argSelectedPdf];

    List<PdfFileModel> data = Get.arguments[argListData];

    totalFile = data.length;

    for (int i = 0; i < data.length; i++) {
      var element = data[i];
      if (element.path == pdfFileModel.path) {
        element.isSelected = true;
      } else {
        element.isSelected = false;
      }
    }
    _pdfList.value = data;
    setSortType(sortBy, sortByType);

    // AppFunc.setTimeout(() {
    //   print('FCUUCUCUCUUCUCUCUCUC $index');
    //
    // }, 50);
  }

  void changeDisplayType(DisplayType type) {
    _displayType.value = type;
  }

  void setSortType(SortBy? sortBy, SortByType? sortByType) {
    _sortBy.value = sortBy ?? SortBy.modify;
    if (sortByType != null) {
      _sortByType.value = sortByType;
    }

    int tmp = 1;
    if (sortByType == SortByType.up) {
      tmp = -1;
    } else {
      tmp = 1;
    }

    if (sortBy == SortBy.modify) {
      pdfList.sort((a, b) {
        if (a.modifyDate != null && b.modifyDate != null) {
          return a.modifyDate!.compareTo(b.modifyDate!) * tmp;
        }
        return 0;
      });
    } else if (sortBy == SortBy.name) {
      pdfList.sort((a, b) {
        if (a.name != null && b.name != null) {
          return a.name!.compareTo(b.name!) * tmp;
        }
        return 0;
      });
    } else if (sortBy == SortBy.size) {
      pdfList.sort((a, b) {
        return (((a.size ?? 0) - (b.size ?? 0)) * tmp) > 0 ? -1 : 1;
      });
    }

    var data = <PdfFileModel>[];
    data.addAll(pdfList);
    _pdfList.value = data;
  }

  void changeSelectedAll() {
    isSelectedAll = !isSelectedAll;

    List<PdfFileModel> data = [];
    for (var element in pdfList) {
      element.isSelected = isSelectedAll;
      data.add(element);
    }
    if (isSelectedAll) {
      selectedCount.value = data.length;
    } else {
      selectedCount.value = 0;
    }

    _pdfList.value = data;
  }

  void setPdfClick(PdfFileModel pdf) {
    List<PdfFileModel> data = [];
    int count = 0;
    for (var element in pdfList) {
      if (element.path == pdf.path) {
        if (element.isSelected == true) {
          element.isSelected = false;
        } else {
          element.isSelected = true;
        }
      }
      if (element.isSelected == true) {
        count++;
      }
      data.add(element);
    }
    selectedCount.value = count;
    _pdfList.value = data;
  }

  void deleteFile() {
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
}
