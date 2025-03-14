import 'package:booklibrary/core/extentions/textstyles.dart';
import 'package:booklibrary/language/i18n.g.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/extentions/string_ext.dart';

class DialogConfirmWidget extends StatelessWidget {
  final Function()? callBack;

  DialogConfirmWidget({Key? key, this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                I18n().confirmDeleteStr.tr,
                style: TextStyles.headerText.copyWith(color: Colors.black),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Touchable(
                      rippleAnimation: true,
                      onTap: () async {
                        Get.back();
                        callBack?.call();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xff536A92),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          I18n().okStr.tr,
                          style: TextStyles.defaultStyle
                              .copyWith(color: Colors.white),
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
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xffEE5A24),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          I18n().cancelStr.tr,
                          style: TextStyles.defaultStyle
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
