import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:booklibrary/screens/print_preview/pdf_print_preview.dart';
import 'package:booklibrary/screens/widget/no_file_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enum/display_type.dart';
import '../widgets/item_pdf_grid.dart';
import '../widgets/item_pdf_vertical.dart';
import 'detail/detail_screen.dart';
import 'widget/content_menu_widget.dart';
import 'widget/qr_scan_widget.dart';

class PdfListContent extends StatelessWidget {
  DisplayType? displayType;
  List<PdfFileModel> pdfList;
  int? progressValue;
  Function(PdfFileModel)? onDelete;
  Function(PdfFileModel)? onFavorite;
  bool? isDownloading;
  Function(PdfFileModel fileModel)? onBackFromDetailScreen;
  bool? isFirstLoading;
  bool? isSearch;
  bool? isSelectedScreen;
  bool? isHome;

  Function(PdfFileModel)? onPress;
  Function(PdfFileModel)? onLongPress;

  PdfListContent(
      {Key? key,
      this.displayType,
      required this.pdfList,
      this.progressValue = 0,
      this.onDelete,
      this.onFavorite,
      this.isDownloading,
      this.isSearch = false,
      this.onBackFromDetailScreen,
      this.isFirstLoading,
      this.isSelectedScreen,
      this.onPress,
      this.onLongPress,
      this.isHome = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return displayType == DisplayType.list
        ? _buildListContent()
        : _buildGridContent();
  }

  _buildListContent() {
    if (isFirstLoading == true) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xff536A92)),
      );
    }

    if (pdfList.isEmpty) {
      return isHome == true ? const QrScanWidget() : const EmptyDataView();
    }
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 16),
      itemBuilder: (c, i) {
        return itemPdfVertical(
          pdfList[i],
          isSearch: isSearch!,
          isSelectedScreen: isSelectedScreen,
          value: progressValue!.toDouble() / 100,
          onLongPress: () {
            onLongPress?.call(pdfList[i]);
          },
          onMenuClick: () {
            _onMenuClick(pdfList[i]);
          },
          onPress: () {
            if (isSelectedScreen == true) {
              onPress?.call(pdfList[i]);
            }
            if (isDownloading != true && isSelectedScreen != true) {
              _gotoDetailScreen(pdfList[i]);
            }
          },
        );
      },
      separatorBuilder: (c, i) {
        return const SizedBox(
          height: 16,
        );
      },
      itemCount: pdfList.length,
    );
  }

  _buildGridContent() {
    if (isFirstLoading == true) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xff536A92)),
      );
    }

    if (pdfList.isEmpty) {
      return const EmptyDataView();
    }
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 16),
      itemBuilder: (c, i) {
        return itemPdfGrid(
          pdfList[i],
          value: progressValue!.toDouble() / 100,
          isSelectedScreen: isSelectedScreen,
          onLongPress: () {
            onLongPress?.call(pdfList[i]);
          },
          onPress: () {
            if (isSelectedScreen == true) {
              onPress?.call(pdfList[i]);
            }
            if (isDownloading != true && isSelectedScreen != true) {
              _gotoDetailScreen(pdfList[i]);
            }
          },
          onMenuClick: () {
            _onMenuClick(pdfList[i]);
          },
        );
      },
      itemCount: pdfList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 106 / 213,
          crossAxisSpacing: 5,
          mainAxisSpacing: 16,
          crossAxisCount: displayType?.getColumn() ?? 3),
    );
  }

  _onMenuClick(PdfFileModel data) {
    Get.bottomSheet(
      ContentMenuWidget(
        data: data,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
        isFavorite: data.isFavorite,
        onDeleteFile: () {
          onDelete?.call(data);
        },
        onFavorite: () {
          onFavorite?.call(data);
        },
        onPrint: () {
          Get.toNamed(PdfPrintPreviewScreen.routeName,
              arguments: data.path ?? '');
        },
      ),
    );
  }

  Future<void> _gotoDetailScreen(PdfFileModel pdfFileModel) async {
    //Lưu vào db recent
    var result = await Get.toNamed(
      DetailScreen.routeName,
      arguments: pdfFileModel,
    );

    if (result is PdfFileModel) {
      onBackFromDetailScreen?.call(pdfFileModel);
    }
  }
}
