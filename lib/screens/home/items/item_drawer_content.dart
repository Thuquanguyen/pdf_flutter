import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';

class ItemDrawerContent extends StatelessWidget {
  const ItemDrawerContent(
      {Key? key, this.title, this.icon, this.action,this.tintColor})
      : super(key: key);

  final String? title;
  final String? icon;
  final Function? action;
  final Color? tintColor;

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: (){
        action?.call();
      },
      child: Container(
        child: Row(
          children: [
            ImageHelper.loadFromAsset(icon ?? AppAssets.icScan,tintColor: tintColor,
                width: 24, height: 24),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Text(
              title ?? '',
              style: AppThemes().general().textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
            )),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
      ),
    );
  }
}
