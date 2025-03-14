import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/enum/display_type.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../core/extentions/textstyles.dart';

Widget buildPageSortView(
    {required String title,
    Function()? onSortClick,
    Function(DisplayType displayType)? onChangeDisplay,
    required DisplayType displayType}) {
  return Row(
    children: [
      Expanded(
        child: Touchable(
          onTap: () {
            onSortClick?.call();
          },
          child: Row(
            children: [
              ImageHelper.loadFromAsset(
                AppAssets.icFillter,
                tintColor: AppThemes().general().iconTheme.color,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(child: Text(
                title,
                style: AppThemes()
                    .general()
                    .textTheme
                    .headline1
                    ?.copyWith(
                    fontSize: 14, fontWeight: FontWeight.w600),
              )),
            ],
          ),
        ),
      ),
      if (displayType != DisplayType.list)
        Touchable(
          onTap: () {
            onChangeDisplay?.call(DisplayType.list);
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            child: ImageHelper.loadFromAsset(AppAssets.icCategory,
                tintColor: AppThemes().general().iconTheme.color,
                width: 19.w,
                height: 15.h),
          ),
        ),
      if (displayType == DisplayType.list)
        DropdownButton<String>(
          icon: ImageHelper.loadFromAsset(AppAssets.icCategory,
              tintColor: AppThemes().general().iconTheme.color,
              width: 19.w,
              height: 15.h),
          underline: const SizedBox(),
          elevation: 16,
          onChanged: (String? newValue) {
            if (newValue == DisplayType.grid2.getName()) {
              onChangeDisplay?.call(DisplayType.grid2);
            } else if (newValue == DisplayType.grid3.getName()) {
              onChangeDisplay?.call(DisplayType.grid3);
            } else if (newValue == DisplayType.grid4.getName()) {
              onChangeDisplay?.call(DisplayType.grid4);
            }
          },
          items: <String>[
            DisplayType.grid2.getName(),
            DisplayType.grid3.getName(),
            DisplayType.grid4.getName(),
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
    ],
  );
}
