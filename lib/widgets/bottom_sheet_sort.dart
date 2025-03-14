import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/enum/sort_by.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../core/extentions/string_ext.dart';
import '../core/extentions/textstyles.dart';

void showBottomSheetSort(SortBy? sortBy, SortByType? sortByType,
    Function(SortBy? sortBy, SortByType? sortByType)? callBack) {
  if (Get.isBottomSheetOpen != true) {
    Get.bottomSheet(
      SortContent(
        callBack: callBack,
        sortBy: sortBy,
        sortByType: sortByType,
      ),
    );
  }
}

class SortContent extends StatefulWidget {
  SortBy? sortBy;
  SortByType? sortByType;
  Function(SortBy? sortBy, SortByType? sortByType)? callBack;

  SortContent({Key? key, this.callBack, this.sortBy, this.sortByType})
      : super(key: key);

  @override
  State<SortContent> createState() => _SortContentState(sortBy, sortByType);
}

class _SortContentState extends State<SortContent> {
  SortBy? sortBy;
  SortByType? sortByType;

  _SortContentState(this.sortBy, this.sortByType);

  @override
  Widget build(BuildContext context) {
    String? downTitle = sortBy?.getSortDownTitle();

    String? upTitle = sortBy?.getSortUpTitle();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              I18n().sortByStr.tr,
              style: TextStyles.defaultStyle.bold.copyWith(fontSize: 16),
            ),
            _buildItem(AppAssets.icDate, I18n().lastModifiedStr.tr,
                sortBy == SortBy.modify, () {
              changeSortBy(SortBy.modify);
            }),
            _buildItem(
                AppAssets.icName, I18n().nameStr.tr, sortBy == SortBy.name, () {
              changeSortBy(SortBy.name);
            }),
            _buildItem(
                AppAssets.icSize, I18n().sizeStr.tr, sortBy == SortBy.size, () {
              changeSortBy(SortBy.size);
            }),
            const Divider(
              height: 1,
              color: Color(0xff111111),
            ),
            downTitle.isNullOrEmpty
                ? const SizedBox()
                : _buildItem(
                    AppAssets.icSortDown,
                    downTitle!,
                    sortByType == SortByType.down,
                    () {
                      changeSortByType(SortByType.down);
                    },
                  ),
            upTitle.isNullOrEmpty
                ? const SizedBox()
                : _buildItem(
                    AppAssets.icSortUp,
                    upTitle!,
                    sortByType == SortByType.up,
                    () {
                      changeSortByType(SortByType.up);
                    },
                  ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Touchable(
                    rippleAnimation: true,
                    onTap: () {
                      widget.callBack?.call(sortBy, sortByType);
                      Get.back();
                    },
                    child: Container(
                      height: 42.w,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xff536A92),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        I18n().okStr.tr,
                        style: TextStyles.defaultStyle
                            .copyWith(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 24.w,
                ),
                Expanded(
                  flex: 1,
                  child: Touchable(
                    rippleAnimation: true,
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 42.w,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xffEE5A24),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        I18n().cancelStr.tr,
                        style: TextStyles.defaultStyle
                            .copyWith(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color selectedColor = const Color(0xffEE5A24);
  Color unSelectedColor = const Color(0xff536A92);

  Widget _buildItem(
      String icon, String title, bool isSelected, Function() callBack) {
    return Touchable(
      onTap: callBack,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            ImageHelper.loadFromAsset(
              icon,
              width: 24.w,
              height: 24.h,
              tintColor: isSelected ? selectedColor : unSelectedColor,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: TextStyles.defaultStyle.copyWith(
                  color: isSelected ? selectedColor : unSelectedColor),
            ),
            const Expanded(child: SizedBox()),
            if (isSelected)
              ImageHelper.loadFromAsset(
                AppAssets.icTick,
                width: 24.w,
                height: 24.h,
              ),
          ],
        ),
      ),
    );
  }

  void changeSortBy(SortBy sortBy) {
    if (this.sortBy != sortBy) {
      setState(() {
        this.sortBy = sortBy;
      });
    }
  }

  void changeSortByType(SortByType sortByType) {
    if (this.sortByType != sortByType) {
      setState(() {
        this.sortByType = sortByType;
      });
    }
  }
}
