import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/language/i18n.g.dart';
import 'package:booklibrary/widgets/state_builder.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'splash_controller.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = '/splash_screen';

  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2000))
    ..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  final StateHandler _stateHandler = StateHandler(SplashScreen.routeName);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ImageHelper.loadFromAsset(AppAssets.imgLogo,
                        width: 253, height: 150)
                  ],
                ),
              ),
              Expanded(
                  flex: 4,
                  child: StateBuilder(
                      builder: () => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (controller.isSetting.value)
                                const SizedBox(
                                  height: 50,
                                ),
                              if (controller.isSetting.value)
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ImageHelper.loadFromAsset(
                                          AppAssets.icEarth,
                                          width: 21,
                                          height: 21),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        I18n().selectLanguageOptionStr.tr,
                                        style: AppThemes()
                                            .general()
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ]),
                              if (controller.isSetting.value)
                                const SizedBox(
                                  height: 14,
                                ),
                              if (controller.isSetting.value)
                                Touchable(
                                  onTap: () {
                                    // show bottom sheet
                                    _modalBottomSheetMenu(controller);
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Obx(() => Text(
                                                  controller.listLanguages
                                                          .isNotEmpty
                                                      ? (controller
                                                              .listLanguages
                                                              .value[controller
                                                                  .id.value]
                                                              .title ??
                                                          '')
                                                      : '',
                                                  style: AppThemes()
                                                      .general()
                                                      .textTheme
                                                      .bodyText1,
                                                ))),
                                        ImageHelper.loadFromAsset(
                                            AppAssets.icDropdown,
                                            width: 17,
                                            height: 10)
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFF6F86AD),
                                            width: 1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        right: 15,
                                        left: 30),
                                  ),
                                ),
                              const SizedBox(
                                height: 17,
                              ),
                              if (controller.isSetting.value)
                                Touchable(
                                    onTap: () {
                                      controller.actionNext();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          I18n().startNowStr.tr,
                                          style: AppThemes()
                                              .general()
                                              .textTheme
                                              .headline1
                                              ?.copyWith(
                                              fontWeight:
                                              FontWeight.bold,color: context.theme.cardColor),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        ImageHelper.loadFromAsset(
                                            AppAssets.icNext,
                                            width: 7,
                                            height: 12,
                                        tintColor: context.theme.cardColor)
                                      ],
                                    )),
                              const Spacer(),
                              if (controller.isShowLoading.value)
                                RotationTransition(
                                  turns: _animation,
                                  child: ImageHelper.loadFromAsset(
                                      AppAssets.icLoading,
                                      width: 48,
                                      height: 48),
                                ),
                              if (controller.isShowLoading.value)
                                const SizedBox(
                                  height: 10,
                                ),
                              if (controller.isShowLoading.value)
                                Obx(() => Text(
                                      controller.loadingMsg.value.tr +
                                          ' (${controller.progressFile.value}%)',
                                      style: AppThemes()
                                          .general()
                                          .textTheme
                                          .bodyText2,
                                    )),
                              const SizedBox(
                                height: 15,
                              ),
                              if (controller.filePath.value.isNotEmpty &&
                                  controller.isShowLoading.value)
                                SizedBox(
                                  child: Text(
                                    controller.filePath.value,
                                    maxLines: 3,
                                    style: AppThemes()
                                        .general()
                                        .textTheme
                                        .bodyText2,
                                  ),
                                  height: 65.h,
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (controller.isShowLoading.value)
                                const SizedBox(
                                  height: 40,
                                ),
                              Text(
                                'Copyright 1Library © . 2022',
                                style: AppThemes().general().textTheme.caption,
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                      routeName: SplashScreen.routeName))
            ],
          ),
        ),
      );
    });
  }

  void _modalBottomSheetMenu(SplashController controller) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 70.h * controller.listLanguages.length,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: const BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Obx(() => SingleChildScrollView(
                      child: Column(
                        children: controller.listLanguages.value
                            .map((data) => RadioListTile<int>(
                                  title: Text(data.title ?? ''),
                                  groupValue: controller.id.value,
                                  value: data.id ?? 0,
                                  onChanged: (val) {
                                    controller.changeLanguage(val ?? 0);
                                    Get.back();
                                  },
                                ))
                            .toList(),
                      ),
                    ))),
          );
        });
  }
}
