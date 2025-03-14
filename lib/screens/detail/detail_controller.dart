import 'package:booklibrary/constants.dart';
import 'package:booklibrary/core/app_functions.dart';
import 'package:booklibrary/data/local/local_db_manager.dart';
import 'package:booklibrary/screens/widget/view_review.dart';
import 'package:booklibrary/utils/message_handler.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

import '../../core/app_functions.dart';
import '../../data/local/pdf_view_setting.dart';
import '../../model/pdf_file_model.dart';

enum ViewMode { vertical, horizontal }

extension ViewModeExt on ViewMode {
  String getName() {
    if (this == ViewMode.horizontal) {
      return 'horizontal';
    }
    return 'vertical';
  }
}

class DetailController extends GetxController {
  PDFViewController? pdfController;

  final Rx<ViewMode> _viewMode = ViewMode.vertical.obs;

  ViewMode? get viewMode => _viewMode.value;

  RxBool snapPage = false.obs;

  Rx<PdfFileModel> pdfFileModel = PdfFileModel().obs;

  RxString passWord = ''.obs;

  RxBool disposePdf = false.obs;

  int currentPage = 1;


  void setCurrentPage(int value) {
    currentPage = value;
  }

  void setDisposePdf(bool value) {
    disposePdf.value = value;
  }

  RxString currentPageDes = ''.obs;

  void setCurrentPageString(String value) {
    currentPageDes.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    if (AppFunc().initWeakLock() == 1) {
      Wakelock.enable();
    }
    pdfFileModel.value = Get.arguments as PdfFileModel;
    currentPage = pdfFileModel.value.currentPage ?? 0;

    _viewMode.value = PdfViewSetting().viewMode ?? ViewMode.vertical;
    snapPage.value = PdfViewSetting().snapPage ?? false;
    MessageHandler().register(RELOAD_DETAIL, handleData);
  }

  @override
  void dispose() {
    super.dispose();
    MessageHandler().unregister(RELOAD_DETAIL);
    Wakelock.disable();
  }

  @override
  void onClose() {
    super.onClose();
    Wakelock.disable();
  }

  void handleData(dynamic pdfFileModel) {
    if (pdfFileModel is PdfFileModel) {
      this.pdfFileModel.value = pdfFileModel;
      currentPage = 0;
      _viewMode.value = PdfViewSetting().viewMode ?? ViewMode.vertical;
      snapPage.value = PdfViewSetting().snapPage ?? false;
    }
  }

  void onBack() async {
    int count = await pdfController?.getPageCount() ?? 1;

    if ((pdfFileModel.value.progress ?? 0) < ((currentPage + 1) / count)) {}
    {
      pdfFileModel.value.progress = ((currentPage + 1) / count);
    }

    pdfFileModel.value.currentPage = (currentPage + 1);

    LocalDbManager().addRecent((pdfFileModel.value));
    MessageHandler().notify(OPEN_RATE_APP);
    Get.back(result: pdfFileModel);
  }

  void gotoPage(int p) {
    pdfController?.setPage(p);
  }

  void setViewMode(ViewMode value) {
    if (viewMode != value) {
      _viewMode.value = value;
      PdfViewSetting().setViewMode(value);
    }
  }

  void removeSnapPage() {
    snapPage.value = false;
    PdfViewSetting().setSnapPage(false);
  }

  void setSnapPage() {
    snapPage.value = true;
    PdfViewSetting().setSnapPage(true);
  }

  void setPassWord(String pass) {
    passWord.value = pass;
  }

  void setPdfController(PDFViewController pdfViewController) {
    pdfController = pdfViewController;
  }
}
