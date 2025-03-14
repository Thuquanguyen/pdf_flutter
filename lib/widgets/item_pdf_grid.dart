import 'dart:typed_data';

import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_themes.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:booklibrary/screens/widget/pdf_thumb_widget.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/extentions/textstyles.dart';
import 'cache_image_provider.dart';
import 'favorite_view.dart';

Widget itemPdfGrid(PdfFileModel data,
    {Function()? onPress,
    Function()? onLongPress,
    Function()? onMenuClick,
    double value = 0,
    bool isPreview = false,
    bool? isSelectedScreen = false}) {
  return Touchable(
    onTap: () {
      onPress?.call();
    },
    onLongPress: onLongPress,
    rippleAnimation: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: AspectRatio(
              aspectRatio: 57 / 72,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                          color: AppThemes().general().canvasColor, width: 1),
                    ),
                    child: PdfThumbWidget(pdfPath: data.path ?? ''),
                  ),
                  if (data.isFavorite == true)
                    const Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: FavoriteView(),
                      ),
                    ),
                  if (isSelectedScreen == true)
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ImageHelper.loadFromAsset(data.isSelected == true
                            ? AppAssets.icSelected
                            : AppAssets.icUnselected),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
        Text(
          data.name ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppThemes()
              .general()
              .textTheme
              .headline1
              ?.copyWith(fontSize: 16.h, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: const Color(0xffA1A1AA), width: 2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                'PDF',
                style: TextStyles.defaultStyle.copyWith(
                    color: const Color(0xffA1A1AA),
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                data.displayDate ?? '',
                style: TextStyles.defaultStyle.copyWith(
                    color: const Color(0xffA1A1AA),
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data.getSize(),
              style: TextStyles.defaultStyle.copyWith(
                  color: const Color(0xffA1A1AA),
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
            if (!(data.isDownload ?? false) &&
                !isPreview &&
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
                  value: data.status == StatusDownload.waiting ? 0 : value,
                  strokeWidth: 3.5.h,
                  color: const Color(0XFF536A92),
                  backgroundColor: const Color(0XFFD4D4D8),
                ),
              ),
          ],
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
        ),
      ],
    ),
  );
}
