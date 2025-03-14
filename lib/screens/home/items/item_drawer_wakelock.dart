import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/app_functions.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/widgets/state_builder.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';

class ItemDrawerWakeLock extends StatelessWidget {
  ItemDrawerWakeLock(
      {Key? key,
      this.title,
      this.action,
      this.tintColor,
      this.isKeepScreen = true,
      this.isSelected = false})
      : super(key: key);

  final String? title;
  bool isSelected;
  bool isKeepScreen;
  final Function? action;
  final Color? tintColor;

  final StateHandler _stateHandler = StateHandler('ItemDrawerWakeLock');

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
              child: Text(
            title ?? '',
            style: AppThemes()
                .general()
                .textTheme
                .bodyText1
                ?.copyWith(fontWeight: FontWeight.w600),
          )),
          const SizedBox(
            width: 8,
          ),
          Touchable(
              onTap: () {
                AppFunc().changeWeakLock(!isSelected ? 1 : 0);
                isSelected = !isSelected;
                _stateHandler.refresh();
              },
              child: StateBuilder(
                  builder: () => ImageHelper.loadFromAsset(
                      isSelected ? AppAssets.icSwitchOn : AppAssets.icSwitchOff,
                      tintColor: tintColor,
                      width: 40,
                      height: 20),
                  routeName: 'ItemDrawerWakeLock')),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
    );
  }
}
