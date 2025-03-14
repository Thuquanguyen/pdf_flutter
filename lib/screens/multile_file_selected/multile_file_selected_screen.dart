import 'package:booklibrary/core/extentions/textstyles.dart';
import 'package:booklibrary/enum/sort_by.dart';
import 'package:booklibrary/screens/multile_file_selected/multiple_selected_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/app_assets.dart';
import '../../core/app_themes.dart';
import '../../core/helpers/image_helper.dart';
import '../../enum/display_type.dart';
import '../../language/i18n.g.dart';
import '../../widgets/app_container.dart';
import '../../widgets/bottom_sheet_sort.dart';
import '../../widgets/page_sort_view.dart';
import '../../widgets/touchable.dart';
import '../pdf_list_content.dart';

enum PageType { home, favorite, recent,qrcode,search, none }

extension PageTypeExt on PageType {
  String getTitle() {
    switch (this) {
      case PageType.home:
        return I18n().allFileStr.tr;
      case PageType.favorite:
        return I18n().favoriteStr.tr;
      case PageType.qrcode:
        return '';
      case PageType.search:
        return I18n().searchStr.tr;
      case PageType.recent:
        return I18n().recentStr.tr;
      default:
        return I18n().allFileStr.tr;
    }
  }

  int getIndex() {
    switch (this) {
      case PageType.home:
        return 0;
      case PageType.recent:
        return 1;
      case PageType.qrcode:
        return 2;
      case PageType.search:
        return 3;
      case PageType.favorite:
        return 4;
      default:
        return -1;
    }
  }
}

class MultipleFileSelectedScreen extends GetView<MultipleSelectedController> {
  static var routeName = '/MultipleFileSelectedScreen';

  const MultipleFileSelectedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      left: true,
      right: true,
      child: AppContainer(
        appBarType: AppBarType.FULL,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Touchable(
                    onTap: () {
                      Get.back();
                    },
                    child: ImageHelper.loadFromAsset(AppAssets.icBack2),
                  ),
                  SizedBox(
                    width: 10.h,
                  ),
                  Obx(
                    () => Text(
                      '${controller.selectedCount.value} Selected',
                      style: TextStyles.headerText
                          .copyWith(
                            color: const Color(0xff3E4F6E),
                            fontSize: 14,
                          )
                          .bold,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Touchable(
                    onTap: () {
                      controller.changeSelectedAll();
                    },
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        child:
                            ImageHelper.loadFromAsset(AppAssets.icSelectedAll)),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    controller.pageType?.getTitle() ?? '',
                    style: AppThemes()
                        .general()
                        .textTheme
                        .headline1
                        ?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    '${controller.totalFile} ${I18n().filesStr.tr}',
                    style: AppThemes()
                        .general()
                        .textTheme
                        .caption
                        ?.copyWith(fontWeight: FontWeight.w600),
                  )
                ],
              ),
              height: 70,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 15),
            ),
            Expanded(
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25)),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Column(
                    children: [
                      Obx(
                        () => buildPageSortView(
                            title: controller.sortBy?.getTitle() ?? '',
                            onChangeDisplay: _onChangeDisplayType,
                            onSortClick: _onSortClick,
                            displayType:
                                controller.displayType ?? DisplayType.list),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: Obx(
                          () => PdfListContent(
                            pdfList: controller.pdfList,
                            displayType: controller.displayType,
                            onDelete: (pdf) {},
                            isSelectedScreen: true,
                            onPress: (pdf) {
                              controller.setPdfClick(pdf);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomView(),
          ],
        ),
      ),
    );
  }

  void _onChangeDisplayType(DisplayType type) {
    controller.changeDisplayType(type);
  }

  void _onSortClick() {
    showBottomSheetSort(
      controller.sortBy,
      controller.sortByType,
      (sortBy, sortByType) {
        controller.setSortType(sortBy, sortByType);
      },
    );
  }

  _buildBottomView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildItemController(AppAssets.icBin, I18n().deleteStr.tr, () {
            controller.deleteFile();
          }),
          if (controller.pageType == PageType.recent)
            _buildItemController(AppAssets.icRemove, I18n().deleteStr.tr, () {
              controller.removeRecent();
            }),
          if (controller.pageType != PageType.favorite)
            _buildItemController(AppAssets.icFavorite, I18n().favoriteStr.tr,
                () {
              controller.addFavorite();
            }),
          if (controller.pageType != PageType.qrcode)
            _buildItemController(AppAssets.icQrScan, '',
                    () {
                  // controller.addFavorite();
                }),
          if (controller.pageType != PageType.search)
            _buildItemController(AppAssets.icSearch, I18n().searchStr.tr,
                    () {
                  // controller.addFavorite();
                }),
          if (controller.pageType == PageType.favorite)
            _buildItemController(
                AppAssets.icUnFavorite, I18n().unFavoriteStr.tr, () {
              controller.removeFavorite();
            }),
          _buildItemController(AppAssets.icShare, I18n().shareStr.tr, () {
            controller.share();
          }),
        ],
      ),
    );
  }

  Widget _buildItemController(String ic, String text, Function onPress) {
    return Touchable(
      onTap: () {
        onPress.call();
      },
      rippleAnimation: true,
      child: Column(
        children: [
          ImageHelper.loadFromAsset(ic),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: AppThemes()
                .general()
                .textTheme
                .headline1
                ?.copyWith(fontSize: 10, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
