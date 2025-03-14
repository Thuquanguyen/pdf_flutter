import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/app_themes.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/enum/display_type.dart';
import 'package:booklibrary/screens/pdf_list_content.dart';
import 'package:booklibrary/widgets/app_container.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'search_controller.dart';

class SearchScreen extends StatelessWidget {
  static const String routeName = '/search_screen';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(
      builder: (controller) => AppContainer(
        appBarType: AppBarType.FULL,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(Get.context!).padding.top,
            ),
            _buildBoxSearch(context, controller),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => Text(
                        '${controller.textSearch.value.isEmpty ? controller.pdfList.length : controller.pdfListSearch.length} ${I18n().filesStr.tr}',
                        style: AppThemes()
                            .general()
                            .textTheme
                            .headline1
                            ?.copyWith(
                                fontSize: 22, fontWeight: FontWeight.w600),
                      )),
                ],
              ),
              height: 70,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 15),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration:  BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25)),
                      color: context.theme.backgroundColor,
                    ),
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Obx(
                          () => PdfListContent(
                          pdfList: controller.textSearch.value.isEmpty
                              ? controller.pdfList
                              : controller.pdfListSearch,
                          displayType: DisplayType.list,
                          isSearch: true,
                          isFirstLoading: false),
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBoxSearch(BuildContext context, SearchController controller) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Touchable(
              onTap: () {
                Get.back();
              },
              child: ImageHelper.loadFromAsset(AppAssets.icBack2)),
          SizedBox(
            width: 10.h,
          ),
          Expanded(
              child: Container(
            height: 40,
            padding: const EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              border: Border.all(width: 1, color: const Color(0XFFE4E4E7)),
            ),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                      child: Obx(() => TextFormField(
                            controller: controller.searchController.value,
                            autofocus: true,
                            onChanged: (String text) {
                              controller.searchAction(text);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(top: 5),
                              suffixIcon: Touchable(
                                  onTap: () {
                                    controller.actionRemove();
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Color(0XFFA1A1AA),
                                  )),
                              hintText: I18n().searchStr.tr,
                              hintStyle:
                                  const TextStyle(color: Color(0XFFE4E4E7)),
                            ),
                          ))),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
