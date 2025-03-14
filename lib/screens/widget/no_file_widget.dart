import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/extentions/textstyles.dart';

class EmptyDataView extends StatelessWidget {
  const EmptyDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageHelper.loadFromAsset(AppAssets.icNoFile,
              width: 94.w, height: 94.h),
          const SizedBox(
            height: 5,
          ),
          Text(
            I18n().noFilesYetStr.tr,
            style: TextStyles.headerText.semiBold
                .copyWith(color: const Color(0xff6F86AD), fontSize: 26),
          )
        ],
      ),
    );
  }
}
