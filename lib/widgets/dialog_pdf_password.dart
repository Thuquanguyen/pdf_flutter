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

class DialogPdfPassWord extends StatelessWidget {
  String? title;
  Function(String)? callback;
  TextInputType? inputType;
  bool? hideSuffixIcon;

  DialogPdfPassWord(
      {Key? key,
      this.title,
      this.callback,
      this.inputType,
      this.hideSuffixIcon})
      : super(key: key);

  TextEditingController controller = TextEditingController();

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
                I18n().enterPassStr.tr,
                style: TextStyles.headerText.copyWith(color: Colors.black),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: controller,
                keyboardType: inputType,
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
                        String pass = controller.text;
                        if (pass.isNullOrEmpty) {
                          return;
                        }
                        callback?.call(pass);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xff536A92),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          I18n().doneStr.tr,
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
