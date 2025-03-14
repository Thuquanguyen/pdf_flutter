import 'dart:io';

import 'package:booklibrary/enum/display_type.dart';
import 'package:booklibrary/enum/sort_by.dart';
import 'package:booklibrary/screens/app_controller.dart';
import 'package:booklibrary/screens/favorite/favorite_controller.dart';
import 'package:booklibrary/screens/pdf_list_content.dart';
import 'package:booklibrary/screens/recent/recent_controller.dart';
import 'package:booklibrary/screens/widget/qr_scan_widget.dart';
import 'package:booklibrary/utils/pdf_file_manager.dart';
import 'package:booklibrary/widgets/app_container.dart';
import 'package:booklibrary/widgets/bottom_sheet_sort.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../widgets/page_sort_view.dart';
import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  static String routeName = '/home_screen';

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => AppContainer(
        // backgroundColor: Colors.transparent,
        floatingActionButton: Platform.isAndroid
            ? GestureDetector(
                onTap: () async {
                  await controller.reloadData();
                },
                child: Container(
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  decoration: const BoxDecoration(
                      color: Colors.deepOrange, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(10),
                ),
              )
            : const SizedBox(),
        appBarType: AppBarType.FULL,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25), topLeft: Radius.circular(25)),
              color: context.theme.backgroundColor,
            ),
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              children: [
                Obx(
                  () => buildPageSortView(
                      title: controller.sortBy?.getTitle() ?? '',
                      onChangeDisplay: _onChangeDisplayType,
                      onSortClick: _onSortClick,
                      displayType: controller.displayType ?? DisplayType.list),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Obx(() => Visibility(child: SizedBox(height: 120.h,),visible: controller.isShowMargin.value,)),
                      Obx(() => Visibility(child: QrScanWidget(
                          isItem: true,
                          onClose: () {
                            controller.closeQRScan();
                          }),visible: (controller.isShowQR.value && PdfManager().pdfList.isNotEmpty),)),
                      Obx(
                        () => PdfListContent(
                          progressValue: controller.progressValue.value,
                          pdfList: controller.pdfList,
                          isHome: true,
                          displayType: controller.displayType,
                          isDownloading: controller.isDownloading.value,
                          onDelete: (pdf) {
                            controller.deleteFile(pdf);
                          },
                          onFavorite: (pdf) {},
                          onBackFromDetailScreen: (pdf) {
                            controller.updateProgress(pdf);
                          },
                          onPress: (pdf) {
                            if (controller.selectedScreen.value == true) {
                              pdf.isSelected = !(pdf.isSelected ?? false);
                              controller.selected(pdf);
                            }
                          },
                          isSelectedScreen: controller.selectedScreen.value,
                          isFirstLoading:
                              controller.isFirstLoading.value == true,
                          onLongPress: (pdf) {
                            // controller.gotoSelectedScreen(pdf);
                            controller.selectedScreen.value = true;
                            pdf.isSelected = true;
                            controller.selected(pdf);
                            controller.setPageType();
                          },
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onChangeDisplayType(DisplayType type) {
    AppController().find<HomeController>()?.changeDisplayType(type);
    AppController().find<RecentController>()?.changeDisplayType(type);
    AppController().find<FavoriteController>()?.changeDisplayType(type);
  }

  void _onSortClick() {
    showBottomSheetSort(AppController().find<HomeController>()?.sortBy,
        AppController().find<HomeController>()?.sortByType,
        (sortBy, sortByType) {
      AppController().find<HomeController>()?.setSortType(sortBy, sortByType);
    });
  }
}
