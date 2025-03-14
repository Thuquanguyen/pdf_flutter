import 'package:booklibrary/enum/display_type.dart';
import 'package:booklibrary/enum/sort_by.dart';
import 'package:booklibrary/screens/home/home_controller.dart';
import 'package:booklibrary/screens/app_controller.dart';
import 'package:booklibrary/screens/recent/recent_controller.dart';
import 'package:booklibrary/widgets/app_container.dart';
import 'package:booklibrary/widgets/bottom_sheet_sort.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/page_sort_view.dart';
import '../main/main_controller.dart';
import '../multile_file_selected/multile_file_selected_screen.dart';
import '../pdf_list_content.dart';
import 'favorite_controller.dart';

class FavoriteScreen extends GetView<FavoriteController> {
  static String routeName = '/FavoriteScreen';

  FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      // backgroundColor: Colors.transparent,
      appBarType: AppBarType.FULL,
      child: Center(
        child: Container(
          decoration:  BoxDecoration(
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
                child: RefreshIndicator(
                  onRefresh: () {
                    controller.loadData();
                    return Future<void>.delayed(const Duration(seconds: 2));
                  },
                  child: Obx(
                    () => PdfListContent(
                      pdfList: controller.pdfList,
                      displayType: controller.displayType,
                      onDelete: (pdf) {
                        controller.deleteFile(pdf);
                        Get.find<HomeController>().deleteFile(pdf);
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
                      onLongPress: (pdf) {
                        // controller.gotoSelectedScreen(pdf);
                        controller.selectedScreen.value = true;
                        pdf.isSelected = true;
                        controller.selected(pdf);
                        AppController()
                            .find<MainController>()
                            ?.setPageType(PageType.favorite);
                      },
                    ),
                  ),
                ),
              ),
            ],
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
    showBottomSheetSort(
      controller.sortBy,
      controller.sortByType,
      (sortBy, sortByType) {
        controller.setSortType(sortBy, sortByType);
      },
    );
  }
}
