import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:flutter/material.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: Color(0xff536A92),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(5), bottomLeft: Radius.circular(5)),
      ),
      child: ImageHelper.loadFromAsset(AppAssets.favorite),
    );
  }
}
