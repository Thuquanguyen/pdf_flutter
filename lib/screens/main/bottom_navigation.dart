import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/app_translations.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/screens/main/tab_page.dart';
import 'package:booklibrary/screens/qr_code/qr_code_screen.dart';
import 'package:booklibrary/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String BOTTOM_TABS = 'BOTTOM_TABS';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation(
      {Key? key, required this.selectedIndex, required this.onSelectPage})
      : super(key: key);
  final int selectedIndex;
  final ValueChanged<int> onSelectPage;

  Color? _color(int index) {
    return selectedIndex == index
        ? AppThemes().general().bottomNavigationBarTheme.unselectedItemColor
        : AppThemes().general().bottomNavigationBarTheme.selectedItemColor;
  }

  static final List<int> _notificationBadge = [0, 0, 0];

  BottomNavigationBarItem _buildItem(int index, Map<String, dynamic> page) {
    // final Map<String, dynamic> page = TABS[index];
    return BottomNavigationBarItem(
      backgroundColor: Colors.transparent,
      icon: Stack(
        children: [
          Container(
            width: 40,
            height: 24,
            margin: const EdgeInsets.only(bottom: 5),
            // color: Colors.red,
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 24,
              height: 24,
              child: ImageHelper.loadFromAsset(
                page['icon'] as String,
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
                tintColor: _color(index),
              ),
            ),
          ),
          if (index == 2)
            SizedBox(
              width: 50,
              height: 50,
              child: ImageHelper.loadFromAsset(
                AppAssets.icQrScanBottom,
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            )
        ],
      ),
      label: (index == 2) ? '' : (page['title'] as String).tr,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black12, width: 0.5))),
      child: BottomNavigationBar(
        key: Key('bottom_bar_${AppTranslations.localeStr}'),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppThemes().general().bottomAppBarColor,
        // backgroundColor: Colors.red,
        selectedItemColor:
            AppThemes().general().bottomNavigationBarTheme.unselectedItemColor,
        elevation: 0,
        unselectedItemColor:
            AppThemes().general().bottomNavigationBarTheme.selectedItemColor,
        currentIndex: selectedIndex,
        selectedFontSize: 12,
        mouseCursor: MouseCursor.uncontrolled,
        unselectedFontSize: 12,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        items: TABS
            .asMap()
            .entries
            .map((page) => _buildItem(page.key, page.value))
            .toList(),
        onTap: (index) {
          if (index == 2) {
            Get.toNamed(QrCodeScreen.routeName);
          } if (index == 3) {
            Get.toNamed(SearchScreen.routeName);
          }else {
            onSelectPage(index);
          }
        },
      ),
    );
  }
}
