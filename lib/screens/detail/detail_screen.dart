import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/app_functions.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/screens/detail/detail_controller.dart';
import 'package:booklibrary/screens/widget/content_menu_widget.dart';
import 'package:booklibrary/screens/widget/view_setting.dart';
import 'package:booklibrary/utils/pdf_file_manager.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/extentions/textstyles.dart';
import '../../widgets/dialog_pdf_password.dart';
import '../print_preview/pdf_print_preview.dart';
import '../widget/dialog_rename.dart';

class DetailScreen extends GetView<DetailController> {
  static String routeName = '/DetailScreen';

  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async {
          controller.onBack();
          return true;
        },
        child: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: Scaffold(
            body: Column(
              children: [
                Obx(() => _buildHeader()),
                Expanded(
                  child: Stack(
                    children: [
                      Obx(
                        () {
                          if (controller.disposePdf.value == true) {
                            return const SizedBox();
                          }
                          return PDFView(
                            key: Key('${controller.pdfFileModel.value.path}'),
                            defaultPage: controller.currentPage,
                            filePath: controller.pdfFileModel.value.path ?? '',
                            enableSwipe: true,
                            swipeHorizontal:
                                controller.viewMode == ViewMode.vertical
                                    ? false
                                    : true,
                            autoSpacing: false,
                            password: controller.pdfFileModel.value.passWord,
                            pageSnap: controller.snapPage.value,
                            onRender: (_pages) {},
                            onError: (error) {
                              if (error.toString().contains(
                                  'Password required or incorrect password')) {
                                Get.dialog(DialogPdfPassWord(
                                  callback: (pass) {
                                    Get.back();
                                    controller.pdfFileModel.value.passWord =
                                        pass;
                                    controller.setDisposePdf(true);
                                    AppFunc.setTimeout(() {
                                      controller.setDisposePdf(false);
                                    }, 50);
                                  },
                                ));
                              }
                            },
                            onPageError: (page, error) {},
                            onViewCreated:
                                (PDFViewController pdfViewController) async {
                              controller.setPdfController(pdfViewController);

                              controller.currentPage =
                                  await pdfViewController.getCurrentPage() ?? 0;
                            },
                            onPageChanged: (int? page, int? total) {
                              controller.setCurrentPage(page ?? 0);
                              controller.setCurrentPageString(
                                  '${(page ?? 0) + 1}/$total');
                            },
                          );
                        },
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 50,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            color: const Color(0xff333333).withOpacity(0.7),
                            child: Obx(
                              () => Text(
                                controller.currentPageDes.value,
                                style: TextStyles.defaultStyle.medium
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      );
    });
  }

  _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 16),
      color: const Color(0xff3F3F46),
      child: Row(
        children: [
          Touchable(
            onTap: () {
              controller.onBack();
            },
            child: ImageHelper.loadFromAsset(AppAssets.icBack,
                width: 44.w, height: 44.h),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              ((controller.pdfFileModel.value.fullTitle?.isNotEmpty == true)
                      ? controller.pdfFileModel.value.fullTitle
                      : controller.pdfFileModel.value.name) ??
                  '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.headerText.medium.copyWith(color: Colors.white),
            ),
          ),
          Touchable(
            onTap: () {
              Get.dialog(
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ContentMenuWidget(
                      data: controller.pdfFileModel.value,
                      isFavorite: controller.pdfFileModel.value.isFavorite,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onDeleteFile: () {
                        Get.back();
                        Get.back();
                      },
                      onPrint: () {
                        Get.toNamed(PdfPrintPreviewScreen.routeName,
                            arguments:
                                controller.pdfFileModel.value.path ?? '');
                      },
                    ),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: ImageHelper.loadFromAsset(AppAssets.icMenu,
                  tintColor: const Color(0xffCCD2E3)),
            ),
          ),
        ],
      ),
    );
  }

  _buildFooter() {
    return Container(
      color: const Color(0xff3F3F46),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildItemFooter(AppAssets.icDetailPage, I18n().pageStr.tr,
              callBack: () {
            Get.dialog(
              DialogRename(
                title: I18n().goToPageStr.tr,
                inputType: TextInputType.number,
                hideSuffixIcon: true,
                callback: (page) async {
                  try {
                    int p = int.parse(page);
                    if (p > 0) {
                      p--;
                    }
                    controller.gotoPage(p);
                  } catch (e) {
                    print('Exception $e');
                  }
                },
              ),
            );
          }),
          _buildItemFooter(
            AppAssets.icDetailSetting,
            I18n().settingsStr.tr,
            callBack: () {
              Get.bottomSheet(
                ViewSetting(
                  controller.viewMode ?? ViewMode.vertical,
                  controller.snapPage.value,
                  callBack: (viewMode, snapPage) {
                    if (controller.snapPage.value == snapPage &&
                        controller.viewMode == viewMode) {
                      return;
                    }
                    controller.setDisposePdf(true);

                    AppFunc.showLoading();
                    AppFunc.setTimeout(() {
                      AppFunc.hideLoading();
                      controller.setDisposePdf(false);
                      controller.setViewMode(viewMode);
                      if (snapPage) {
                        controller.setSnapPage();
                      } else {
                        controller.removeSnapPage();
                      }
                    }, 100);
                  },
                ),
              );
            },
          ),
          _buildItemFooter(
            AppAssets.icShare,
            I18n().shareStr.tr,
            icColor: Colors.white,
            callBack: () {
              PdfManager().shareFile(controller.pdfFileModel.value.path ?? '');
            },
          ),
        ],
      ),
    );
  }

  _buildItemFooter(String icon, String title,
      {Color? icColor, Function()? callBack}) {
    return Touchable(
      onTap: () {
        callBack?.call();
      },
      child: Column(
        children: [
          ImageHelper.loadFromAsset(icon, tintColor: icColor),
          const SizedBox(
            height: 3,
          ),
          Text(
            title,
            style: TextStyles.defaultStyle.medium
                .copyWith(fontSize: 10, color: Colors.white),
          )
        ],
      ),
    );
  }
}
