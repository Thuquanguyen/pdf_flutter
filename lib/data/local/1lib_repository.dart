import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:extension/string.dart';

class OneLibRepository {
  final String name = '1pdf';
  late Box<PdfFileModel> libBox;

  static final OneLibRepository _singleton = OneLibRepository._internal();

  factory OneLibRepository() {
    return _singleton;
  }

  OneLibRepository._internal();

  Future<void> init() async {
    libBox = await Hive.openBox<PdfFileModel>(name);
  }

  // Future<void> addOneLib(PdfFileModel data) async {
  //   if (data.path == null) {
  //     return;
  //   }
  //   return libBox.put(data.path, data);
  // }
  //
  // Future<void> removeOneLib(PdfFileModel data) async {
  //   if (data.path == null) {
  //     return;
  //   }
  //   return libBox.delete(data.path);
  // }
  //
  // Future<List<PdfFileModel>> getListOneLib() async {
  //   return libBox.values.toList();
  // }
}
