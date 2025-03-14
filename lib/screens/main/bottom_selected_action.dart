import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/screens/home/home_controller.dart';
import 'package:booklibrary/screens/main/main_controller.dart';
import 'package:booklibrary/screens/app_controller.dart';
import 'package:booklibrary/screens/multile_file_selected/multile_file_selected_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_themes.dart';
import '../../core/helpers/image_helper.dart';
import '../../language/i18n.g.dart';
import '../../widgets/touchable.dart';

class BottomSelectedAction extends GetView<MainController> {
  PageType? pageType;

  BottomSelectedAction({Key? key, this.pageType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildItemController(AppAssets.icBin, I18n().deleteStr.tr, () {
            AppController().find<MainController>()?.deleteFile();
          }),
          if (pageType == PageType.recent)
            _buildItemController(AppAssets.icRemove, I18n().removeStr.tr, () {
              AppController().find<MainController>()?.removeRecent();
            }),
          if (pageType != PageType.favorite)
            _buildItemController(AppAssets.icFavorite, I18n().favoriteStr.tr,
                () {
              AppController().find<MainController>()?.addFavorite();
            }),
          if (pageType == PageType.favorite)
            _buildItemController(
                AppAssets.icUnFavorite, I18n().unFavoriteStr.tr, () {
              AppController().find<MainController>()?.removeFavorite();
            }),
          _buildItemController(AppAssets.icShare, I18n().shareStr.tr, () {
            AppController().find<MainController>()?.share();
          }),
        ],
      ),
    );
  }

  Widget _buildItemController(String ic, String text, Function onPress) {
    return Touchable(
      onTap: () {
        onPress.call();
      },
      rippleAnimation: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageHelper.loadFromAsset(ic),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: AppThemes()
                .general()
                .textTheme
                .headline1
                ?.copyWith(fontSize: 10, fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
