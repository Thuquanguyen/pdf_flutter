import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/app_dimens.dart';
import 'package:booklibrary/core/app_functions.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/screens/favorite/favorite_screen.dart';
import 'package:booklibrary/screens/home/home_screen.dart';
import 'package:booklibrary/screens/home/items/item_drawer_content.dart';
import 'package:booklibrary/screens/home/items/item_drawer_normal.dart';
import 'package:booklibrary/screens/home/items/item_drawer_setting.dart';
import 'package:booklibrary/screens/home/items/item_drawer_wakelock.dart';
import 'package:booklibrary/screens/main/bottom_navigation.dart';
import 'package:booklibrary/screens/main/bottom_selected_action.dart';
import 'package:booklibrary/screens/main/main_controller.dart';
import 'package:booklibrary/screens/multile_file_selected/multile_file_selected_screen.dart';
import 'package:booklibrary/screens/qr_code/qr_code_screen.dart';
import 'package:booklibrary/screens/recent/recent_screen.dart';
import 'package:booklibrary/screens/search/search_screen.dart';
import 'package:booklibrary/screens/splash/language_controller.dart';
import 'package:booklibrary/widgets/lazy_widget.dart';
import 'package:booklibrary/widgets/state_builder.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = '/main_screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    context.theme;
    return GetBuilder<MainController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async {
          if (controller.selectedPageType.value != PageType.none) {
            controller.removeSelected();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          // backgroundColor: const Color(0XFFF2F2F2),
          key: _scaffoldKey,
          drawerEnableOpenDragGesture: false,
          appBar: AppBar(
            // backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            leading: Obx(
              () => controller.selectedPageType.value == PageType.none
                  ? Touchable(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                      child: const Icon(Icons.sort),
                    )
                  : Touchable(
                      onTap: () {
                        controller.removeSelected();
                      },
                      child: const Icon(Icons.arrow_back),
                    ),
            ),
            titleSpacing: 0,
            title: Obx(
              () => controller.selectedPageType.value == PageType.none
                  ? ImageHelper.loadFromAsset(AppAssets.imgLogoIn,
                      width: 60, height: 50)
                  : Text(
                      '${controller.selectedFile.value} ${I18n().fileSelectedStr.tr}',
                      style: AppThemes()
                          .general()
                          .textTheme
                          .headline1
                          ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
            ),
            // actions: [
            //   _buildAction(controller),
            // ],
          ),
          body: Column(
            children: [
              if (controller.selectedIndex.value != 2 &&
                  controller.selectedIndex.value != 3)
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => Text(
                          controller.title.value,
                          style: AppThemes()
                              .general()
                              .textTheme
                              .headline1
                              ?.copyWith(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Obx(
                        () => Text(
                          '${controller.totalFile.value} ${I18n().filesStr.tr}',
                          style: AppThemes()
                              .general()
                              .textTheme
                              .caption
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                ),
              Expanded(
                child: Container(
                  child: Obx(
                    () => IndexedStack(
                        index: controller.selectedIndex.value,
                        children: screens),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: Obx(() {
              if (controller.selectedPageType.value == PageType.none) {
                return BottomNavigation(
                  selectedIndex: controller.selectedIndex.value,
                  onSelectPage: (index) {
                    controller.changePage(index);
                  },
                );
              } else {
                return Obx(
                  () => BottomSelectedAction(
                    pageType: controller.selectedPageType.value,
                  ),
                );
              }
            }),
          ),
          drawer: Drawer(
            backgroundColor: AppThemes().general().backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AppDimens.topSafeAreaPadding,
                ),
                ItemDrawerNormal(
                  title: 'PDF Reader',
                  icon: AppAssets.icStar,
                  tintColor: AppThemes().general().iconTheme.color,
                ),
                const Divider(
                  height: 1,
                ),
                const SizedBox(
                  height: 15,
                ),
                // ItemDrawerContent(
                //   title: I18n().browsePdfStr.tr,
                //   tintColor: AppThemes().general().iconTheme.color,
                //   icon: AppAssets.icBrowse,
                //   action: () async {
                //     _scaffoldKey.currentState?.openEndDrawer();
                //     controller.pickerFile();
                //   },
                // ),
                ItemDrawerContent(
                  title: I18n().shareAppStr.tr,
                  icon: AppAssets.icShareApp,
                  tintColor: AppThemes().general().iconTheme.color,
                  action: () {
                    controller.shareApplication();
                  },
                ),
                ItemDrawerContent(
                  title: I18n().contactStr.tr,
                  icon: AppAssets.icContact,
                  tintColor: AppThemes().general().iconTheme.color,
                  action: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                    controller.sendContact();
                  },
                ),
                ItemDrawerContent(
                  title: I18n().selectLanguageOptionStr.tr,
                  tintColor: AppThemes().general().iconTheme.color,
                  icon: AppAssets.icLanguage,
                  action: () {
                    _modalBottomSheetMenu(controller);
                  },
                ),
                ItemDrawerContent(
                  title: I18n().qrScanStr.tr,
                  icon: AppAssets.icQrScan,
                  tintColor: AppThemes().general().iconTheme.color,
                  action: () {
                    _scaffoldKey.currentState?.openEndDrawer();
                    Get.toNamed(QrCodeScreen.routeName);
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                const Divider(
                  height: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    I18n().settingsStr.tr,
                    style: AppThemes()
                        .general()
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ItemDrawerWakeLock(
                  title: I18n().keepOnScreenStr.tr,
                  isSelected: AppFunc().initWeakLock() == 1,
                ),
                StateBuilder(
                  builder: () => ItemDrawerSetting(
                    title: I18n().darkModeStr.tr,
                    isSelected: AppThemes().general() == AppThemes.darkTheme(),
                  ),
                  routeName: MainScreen.routeName,
                  holder: 'theme',
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAction(MainController controller) {
    return Obx(() {
      if (controller.selectedPageType.value == PageType.none) {
        return Row(
          children: [
            Touchable(
                onTap: () {
                  Get.toNamed(SearchScreen.routeName);
                },
                child: ImageHelper.loadFromAsset(AppAssets.icSearch,
                    tintColor: AppThemes().general().iconTheme.color,
                    width: 24,
                    height: 24)),
            const SizedBox(
              width: 17,
            ),
            Touchable(
              onTap: () {
                Get.toNamed(QrCodeScreen.routeName);
              },
              child: ImageHelper.loadFromAsset(AppAssets.icQrScan,
                  tintColor: AppThemes().general().iconTheme.color,
                  width: 17,
                  height: 21),
            ),
            const SizedBox(
              width: 22,
            )
          ],
        );
      } else {
        return Touchable(
          onTap: () {
            controller.changeSelectedAll();
          },
          child: Container(
              padding: const EdgeInsets.all(5),
              child: ImageHelper.loadFromAsset(
                AppAssets.icSelectedAll,
                tintColor: AppThemes().general().iconTheme.color,
              )),
        );
      }
    });
  }

  final List<Widget> screens = [
    LazyWidget(
      child: HomeScreen(),
      delay: 0,
    ),
    LazyWidget(
      child: RecentScreen(),
      delay: 200,
    ),
    LazyWidget(
      child: Container(),
      delay: 200,
    ),
    LazyWidget(
      child: Container(),
      delay: 200,
    ),
    LazyWidget(
      child: FavoriteScreen(),
      delay: 200,
    ),
  ];

  void _modalBottomSheetMenu(MainController controller) {
    if (LanguageController().listLanguages.isEmpty) return;
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 70.h * LanguageController().listLanguages.length,
          color: Colors.transparent, //could change this to Color(0xFF737373),
          //so you don't have to change MaterialApp canvasColor
          child: Container(
            decoration: const BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            child: Obx(
              () => Column(
                children: LanguageController()
                    .listLanguages
                    .toList()
                    .map((data) => RadioListTile<int>(
                          title: Text(data.title ?? ''),
                          groupValue: controller.id.value,
                          value: data.id ?? 0,
                          onChanged: (val) {
                            controller.changeLanguage(data.id ?? 0);
                            Get.back();
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
