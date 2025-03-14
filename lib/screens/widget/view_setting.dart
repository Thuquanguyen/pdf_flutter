import 'dart:ffi';

import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/screens/detail/detail_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/extentions/textstyles.dart';
import '../../widgets/touchable.dart';

class ViewSetting extends StatefulWidget {
  ViewMode viewMode;
  bool snapPage;
  Function(ViewMode viewMode, bool snap) callBack;

  ViewSetting(this.viewMode, this.snapPage, {Key? key, required this.callBack})
      : super(key: key);

  @override
  State<ViewSetting> createState() => _ViewSettingState(viewMode, snapPage);
}

class _ViewSettingState extends State<ViewSetting> {
  ViewMode viewMode;
  bool snapPage;

  _ViewSettingState(this.viewMode, this.snapPage);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18n().viewSettingStr.tr,
            style: TextStyles.defaultStyle.bold.copyWith(fontSize: 16),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            I18n().viewModeStr.tr,
            style: TextStyles.defaultStyle.copyWith(fontSize: 16),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Touchable(
                  onTap: () {
                    setState(() {
                      viewMode = ViewMode.horizontal;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      color: viewMode == ViewMode.horizontal
                          ? const Color(0xff536A92)
                          : const Color(0xffE4E4E7),
                    ),
                    child: Column(
                      children: [
                        ImageHelper.loadFromAsset(AppAssets.icHorizontal,
                            tintColor: viewMode == ViewMode.horizontal
                                ? Colors.white
                                : Colors.black),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          I18n().horizontalStr.tr,
                          style: TextStyles.defaultStyle.copyWith(
                              color: viewMode == ViewMode.horizontal
                                  ? Colors.white
                                  : Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Touchable(
                  onTap: () {
                    setState(
                      () {
                        viewMode = ViewMode.vertical;
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: viewMode == ViewMode.vertical
                          ? const Color(0xff536A92)
                          : const Color(0xffE4E4E7),
                    ),
                    child: Column(
                      children: [
                        ImageHelper.loadFromAsset(AppAssets.icVertical,
                            tintColor: viewMode == ViewMode.vertical
                                ? Colors.white
                                : Colors.black),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          I18n().verticalStr.tr,
                          style: TextStyles.defaultStyle.copyWith(
                              color: viewMode == ViewMode.vertical
                                  ? Colors.white
                                  : Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                I18n().pageByPageStr.tr,
                style: TextStyles.defaultStyle.copyWith(fontSize: 16),
              ),
              CupertinoSwitch(
                value: snapPage,
                onChanged: (value) {
                  setState(() {
                    snapPage = value;
                  });
                },
                activeColor: const Color(0xff536A92),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Touchable(
                  rippleAnimation: true,
                  onTap: () {
                    widget.callBack.call(viewMode, snapPage);
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
    );
  }
}
