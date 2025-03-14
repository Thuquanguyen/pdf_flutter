import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/extentions/textstyles.dart';
import '../../core/extentions/date_ext.dart';

class DetailDialogWidget extends StatelessWidget {
  PdfFileModel pdfFileModel;

  DetailDialogWidget(this.pdfFileModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              I18n().detailStr.tr,
              style: TextStyles.headerText.semiBold
                  .copyWith(color: Colors.black),
            ),
            _buildItem(I18n().fileNameStr.tr, ((pdfFileModel.fullTitle?.isNotEmpty == true)
                ? pdfFileModel.fullTitle
                : pdfFileModel.name) ??
                ''),
            _buildItem(I18n().pathStr.tr, pdfFileModel.path ?? ''),
            _buildItem(I18n().lastModifiedStr.tr,
                pdfFileModel.modifyDate?.getDateTimeString() ?? ''),
            _buildItem(I18n().lastViewedStr.tr,
                pdfFileModel.viewedDate?.getDateTimeString() ?? ''),
            _buildItem(I18n().sizeStr.tr, pdfFileModel.getSize()),
            Touchable(
              onTap: () {
                Get.back();
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                margin: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 10),
                decoration: BoxDecoration(
                    color: const Color(0xff536A92),
                    borderRadius: BorderRadius.circular(3)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  I18n().closeStr.tr,
                  style:
                      TextStyles.defaultStyle.copyWith(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildItem(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.defaultStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyles.defaultStyle
                .copyWith(color: const Color(0xff6F86AD)),
          ),
        ],
      ),
    );
  }
}
