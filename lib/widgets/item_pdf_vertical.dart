import 'dart:typed_data';

import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_themes.dart';
import 'package:booklibrary/core/extentions/textstyles.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:booklibrary/screens/widget/pdf_thumb_widget.dart';
import 'package:booklibrary/widgets/favorite_view.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'cache_image_provider.dart';

Widget itemPdfVertical(
  PdfFileModel data, {
  Function()? onPress,
  Function()? onLongPress,
  Function()? onMenuClick,
  bool? hideMenuIcon,
  double value = 0,
  bool isDownloading = false,
  bool isSearch = false,
  bool isPreview = false,
  bool? isSelectedScreen = false,
}) {
  return Touchable(
    key: Key(data.path ?? ''),
    onTap: () {
      onPress?.call();
    },
    onLongPress: () {
      onLongPress?.call();
    },
    rippleAnimation: true,
    child: Container(
      width: double.infinity,
      height: 92.h,
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border:
                    Border.all(color: AppThemes()
                        .general().canvasColor, width: 1)),
                width: 52.w,
                height: 80.h,
                child: PdfThumbWidget(pdfPath: data.path ?? ''),
              ),
              if (data.isFavorite == true)
                const Positioned.fill(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: FavoriteView(),
                  ),
                )
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                data.name ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppThemes()
                                    .general()
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                        fontSize: 16.h,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                        color: const Color(0xffA1A1AA),
                                        width: 2),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(
                                    'PDF',
                                    style: TextStyles.defaultStyle.copyWith(
                                        color: const Color(0xffA1A1AA),
                                        fontSize: 10.h,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  data.displayDate ?? '',
                                  style: TextStyles.defaultStyle.copyWith(
                                      color: const Color(0xffA1A1AA),
                                      fontSize: 10.h,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  data.getSize(),
                                  style: TextStyles.defaultStyle.copyWith(
                                      color: const Color(0xffA1A1AA),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            if (data.sortPath?.isNotEmpty == true)
                              SizedBox(
                                height: 2.h,
                              ),
                            if (data.sortPath?.isNotEmpty == true)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ImageHelper.loadFromAsset(AppAssets.icFolder,
                                      width: 15.w, height: 15.h),
                                  Expanded(
                                    child: Text(
                                      data.sortPath ?? '',
                                      maxLines: 1,
                                      style: TextStyles.defaultStyle.copyWith(
                                          color: const Color(0xffA1A1AA),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (isSelectedScreen == true)
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          child: ImageHelper.loadFromAsset(
                              data.isSelected == true
                                  ? AppAssets.icSelected
                                  : AppAssets.icUnselected),
                        ),
                      if (hideMenuIcon != true &&
                          !(data.isDownload ?? false) &&
                          !isPreview &&
                          !isSearch &&
                          isSelectedScreen != true)
                        Touchable(
                          onTap: () {
                            onMenuClick?.call();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            child: ImageHelper.loadFromAsset(AppAssets.icMenu),
                          ),
                        ),
                      if ((data.isDownload ?? false) && !isPreview)
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          alignment: Alignment.center,
                          width: 20.h,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            value: data.status == StatusDownload.downloading
                                ? value
                                : 0,
                            strokeWidth: 3.5.h,
                            color: const Color(0XFF536A92),
                            backgroundColor: const Color(0XFFD4D4D8),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.5,
                      child: LinearProgressIndicator(
                        value: data.getProgress() ?? 0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xff536A92).withOpacity(0.7),
                        ),
                        backgroundColor: Colors.transparent,
                        minHeight: 1,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
