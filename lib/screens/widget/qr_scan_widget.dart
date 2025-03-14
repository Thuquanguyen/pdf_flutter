import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/screens/qr_code/qr_code_screen.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/extentions/textstyles.dart';

class QrScanWidget extends StatelessWidget {
  const QrScanWidget({Key? key, this.isItem = false, this.onClose})
      : super(key: key);

  final bool? isItem;
  final Function? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isItem == true)
              SizedBox(
                child: Row(
                  children: [
                    const Spacer(),
                    Touchable(
                      onTap: () {
                        onClose?.call();
                      },
                      child: ImageHelper.loadFromAsset(AppAssets.icCloseCircle,
                          width: 24.w, height: 24.h),
                    )
                  ],
                ),
                width: MediaQuery.of(context).size.width,
              ),
            ImageHelper.loadFromAsset(AppAssets.imgQrScan,
                width: isItem == true ? 50.w : 94.w,
                height: isItem == true ? 50.w : 94.h),
            const SizedBox(
              height: 5,
            ),
            Touchable(
              onTap: () {
                Get.toNamed(QrCodeScreen.routeName);
              },
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0XFF6F86AD),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: Center(
                  child: Text(
                    I18n().scanQrCodeOnWebStr.tr,
                    style: TextStyles.headerText.semiBold
                        .copyWith(color: Colors.white, fontSize: 14),
                  ),
                ),
                width: 174.w,
                height: 42.h,
              ),
            )
          ],
        ),
      ),
    );
  }
}
