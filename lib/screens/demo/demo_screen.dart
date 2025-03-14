import 'package:booklibrary/core/app_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'demo_controller.dart';

class DemoScreen extends StatefulWidget {
  static const String routeName = '/demo_screen';
  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  @override
  Widget build(BuildContext context) {
    return  GetBuilder<DemoController>(builder: (controller) {
        return MaterialApp(home: Scaffold(
          appBar: AppBar(
            title: Text('Plugin example app'),
          ),
          body: Center(
            child: Column(children: [
              Text(I18n().loginStr.tr),
              const SizedBox(height: 100,),
              InkWell(onTap: (){
                _modalBottomSheetMenu(controller);
              },child: Text('CHANGE LANGUAGE'),)
            ],mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,),
          ),
        ),);
      });
  }

  void _modalBottomSheetMenu(DemoController controller) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 70.h * 3,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: const BoxDecoration(
                  // color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Obx(() => SingleChildScrollView(child:
                Column(
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
                ),))),
          );
        });
  }
}
