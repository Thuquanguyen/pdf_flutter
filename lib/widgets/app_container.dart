import 'dart:async';

import 'package:booklibrary/core/app_dimens.dart';
import 'package:booklibrary/core/app_functions.dart';
import 'package:booklibrary/core/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum AppBarType {
  NORMAL,
  HOME,
  FULL,
  OVERLAY,
  CUSTOM_APP_BAR,
}

int _countClick = 0;
StreamSubscription? _clickTimeout;

class AppContainer extends StatelessWidget {
  const AppContainer({
    Key? key,
    this.title,
    this.titleImage,
    required this.child,
    this.drawer,
    this.appBarType = AppBarType.NORMAL,
    this.onTap,
    this.onTapDown,
    this.onBack,
    this.hideBackButton = false,
    this.actions,
    this.customAppBar,
    this.resizeToAvoidBottomInset = false,
    this.backgroundColor = Colors.transparent,
    this.floatingActionButton,
    this.colorBack,
    this.colorTitle,
    this.onDoubleTap,
  }) : super(key: key);

  final String? title;
  final String? titleImage;
  final Widget child;
  final Widget? customAppBar;
  final Widget? drawer;
  final AppBarType appBarType;
  final Function? onTap;
  final Function? onTapDown;
  final Function? onDoubleTap;
  final Function? onBack;
  final Color? colorBack;
  final Color? colorTitle;
  final bool hideBackButton;
  final Color backgroundColor;
  final List<Widget>? actions;
  final bool resizeToAvoidBottomInset;
  final Widget? floatingActionButton;

  double heightOfContent() {
    return Get.size.height - heightOfNativeAppBar(appBarType);
  }

  static double heightOfNativeAppBar(AppBarType appBarType) {
    if (appBarType == AppBarType.FULL || Get.context == null) {
      return 0;
    }
    return MediaQuery.of(Get.context!).padding.top + kToolbarHeight;
  }

  Widget renderAppBar(BuildContext context) {
    if (appBarType == AppBarType.CUSTOM_APP_BAR && customAppBar != null) {
      return customAppBar!;
    }
    return AppBar(
      actions: actions,
      elevation: 0,
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      leading: hideBackButton
          ? const SizedBox(height: 0)
          : IconButton(
              icon:  Icon(Icons.arrow_back, size: 24, color: colorBack ?? AppThemes().general().canvasColor),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () => {
                if (onBack == null) {Get.back()} else {onBack?.call()}
              },
            ),
      backgroundColor: Colors.transparent,
      title: (titleImage != null && titleImage != '')
          ? Image.asset(
              titleImage!,
              width: 60,
              height: 42,
              fit: BoxFit.contain,
            )
          : Text(
              title ?? '',
              style: AppThemes()
                  .general()
                  .textTheme
                  .headline1
                  ?.copyWith(color: colorTitle ?? AppThemes().general().canvasColor),
              // style: TextStyles.gHeader.whiteColor,
            ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: Get.size.height,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      ),
      if (appBarType == AppBarType.HOME)
        Container(
          color: Colors.white,
          child: Container(
            width: Get.size.width,
            height: heightOfNativeAppBar(appBarType),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF525EA1),
                  Color(0xFF06B2F4),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
      // Image.asset(XR().assetsImage.img_appbar_bg,
      //     width: Get.size.width, height: heightOfNativeAppBar(), fit: BoxFit.cover),
      GestureDetector(
        onTapDown: (onTapDetails) {
          onTapDown?.call();
        },
        onDoubleTap: () {
          onDoubleTap?.call();
        },
        onTap: () {
          if (onTap != null) {
            onTap?.call();
          }else{
            AppFunc.hideKeyboard();
          }
        },
        child: Scaffold(
          // backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          body: (title != null && appBarType == AppBarType.OVERLAY)
              ? Stack(
            children: [
              SizedBox(
                child: child,
                height: AppDimens.screenHeight,
                width: AppDimens.screenWidth,
              ),
              SizedBox(
                child: renderAppBar(context),
                height: AppDimens.topSafeAreaPadding + kToolbarHeight,
              ),
            ],
          )
              :Column(
            children: [
              if (appBarType != AppBarType.FULL) renderAppBar(context),
              if (appBarType != AppBarType.FULL)
                Divider(
                  height: 1,
                  color: Colors.grey.withAlpha(150),
                ),
              Expanded(child: SizedBox(width: Get.size.width, child: child)),
            ],
          ),
          floatingActionButton: floatingActionButton,
          drawer: drawer ?? const SizedBox(),
        ),
      ),
    ]);
  }
}
