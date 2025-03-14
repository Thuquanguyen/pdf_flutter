import 'package:booklibrary/data/local/local_db_manager.dart';
import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:booklibrary/utils/pdf_file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  Rx<TextEditingController> searchController = TextEditingController().obs;

  final RxList<PdfFileModel> pdfList = RxList();
  final RxList<PdfFileModel> pdfListSearch = RxList();

  RxString textSearch = ''.obs;
  RxBool isFirstLoading = true.obs;


  @override
  void onInit() {
    pdfList.value = PdfManager().pdfList;
    super.onInit();
  }

  void searchAction(String text) {
    textSearch.value = text;
    pdfListSearch.clear();
    pdfList.forEach((element) {
      if (element.name?.toLowerCase().contains(text.toLowerCase()) ?? false) {
        pdfListSearch.add(element);
      }
    });
  }

  void removeFirstLoading() {
    isFirstLoading.value = false;
  }

  void actionRemove() {
    if (searchController.value.text.isNotEmpty) {
      searchController.value.text = '';
      textSearch.value = '';
    }
  }
}
