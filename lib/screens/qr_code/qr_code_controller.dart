import 'package:booklibrary/language/i18n.g.dart';
import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:booklibrary/screens/qr_code/model/qr_model.dart';
import 'package:booklibrary/widgets/item_pdf_shimmer.dart';
import 'package:booklibrary/widgets/item_pdf_vertical.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrCodeController extends GetxController {

  Rx<PdfFileModel> pdfFileModel = PdfFileModel().obs;
  Rx<QrModel> qrData = QrModel().obs;

  void setPdfFile(PdfFileModel pdfFile){
    pdfFileModel.value = pdfFile;
    refresh();
  }
}
