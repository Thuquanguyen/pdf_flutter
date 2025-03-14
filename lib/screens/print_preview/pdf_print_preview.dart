import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../core/app_assets.dart';
import '../../core/app_themes.dart';
import '../../core/extentions/textstyles.dart';
import '../../core/helpers/image_helper.dart';
import '../../widgets/touchable.dart';

class PdfPrintPreviewScreen extends StatelessWidget {
  static var routeName = '/PdfPrintPreviewScreen';

  const PdfPrintPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      left: true,
      right: true,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 16),
              color: const Color(0xff3F3F46),
              child: Row(
                children: [
                  Touchable(
                    onTap: () {
                      Get.back();
                    },
                    child: ImageHelper.loadFromAsset(AppAssets.icBack,
                        width: 44.w, height: 44.h),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      'Preview',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:TextStyles.headerText.medium.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PdfPreview(
                build: (format) => _generatePdf(format),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) {
    String path = Get.arguments as String;
    return File(path).readAsBytes();
  }
}
