import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:booklibrary/utils/pdf_file_manager.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/extentions/textstyles.dart';
import '../../core/extentions/string_ext.dart';

class DialogRename extends StatelessWidget {
  String? title;
  Function(String)? callback;
  TextInputType? inputType;
  bool? hideSuffixIcon;
  String? text;

  DialogRename(
      {Key? key,
      this.title,
      this.callback,
      this.inputType,
      this.hideSuffixIcon,
      this.text})
      : super(key: key);

  late TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    controller = TextEditingController(text: text);
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
                title ?? '',
                style: TextStyles.headerText.copyWith(color: Colors.black),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: controller,
                keyboardType: inputType,
                autofocus: true,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xffA1A1AA), width: 1.0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xffA1A1AA), width: 1.0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  suffixIconConstraints:
                      BoxConstraints(minHeight: 24.w, minWidth: 24.w),
                  suffixIcon: hideSuffixIcon == true
                      ? null
                      : Touchable(
                          onTap: () {
                            controller.text = '';
                          },
                          child: Container(
                            padding: const EdgeInsets.only(right: 5),
                            child: ImageHelper.loadFromAsset(AppAssets.icClear,
                                width: 20.w, height: 20.h),
                          ),
                        ),
                ),
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
                        String name = controller.text;
                        if (name.isNullOrEmpty) {
                          return;
                        }
                        Get.back();
                        callback?.call(name);
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
