import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_themes.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemDrawerNormal extends StatelessWidget {
  const ItemDrawerNormal(
      {Key? key, this.title, this.icon, this.action,this.tintColor})
      : super(key: key);

  final String? title;
  final String? icon;
  final Function? action;
  final Color? tintColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ImageHelper.loadFromAsset(AppAssets.imgLogo,width: 70,height: 60),
          const Spacer(),
          ImageHelper.loadFromAsset(icon ?? AppAssets.icScan,tintColor: const Color(0XFFEE5A24)),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 17),
    );
  }
}
