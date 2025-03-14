import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_color.dart';
import 'package:booklibrary/core/extentions/shimmer_ext.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget itemPdfShimmer() {
  return Container(
    width: double.infinity,
    height: 85.h,
    alignment: Alignment.center,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageHelper.loadFromAsset(
          AppAssets.pdfThumb,
          width: 52.w,
          height: 80.h,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 300,
                height: 20,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ).withShimmer(visible: true),
              Container(
                width: 100,
                height: 20,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ).withShimmer(visible: true),
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ).withShimmer(visible: true),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 60,
                    height: 20,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ).withShimmer(visible: true),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 60,
                    height: 20,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ).withShimmer(visible: true),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
