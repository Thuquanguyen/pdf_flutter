import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:hive/hive.dart';

class TotalRepository {
  final String name = 'totalBox';

  late Box<PdfFileModel> totalBox;

  static final TotalRepository _singleton = TotalRepository._internal();

  factory TotalRepository() {
    return _singleton;
  }

  Future<void> init() async {
    totalBox = await Hive.openBox<PdfFileModel>(name);
  }

  TotalRepository._internal();

  Future<void> addTotal(PdfFileModel data) async {
    if (totalBox.containsKey(data.path)) {
      return;
    }
    return totalBox.put(data.path, data);
  }

  Future<int> clearList() async {
    return totalBox.clear();
  }

  Future<List<PdfFileModel>> getListTotal() async {
    return totalBox.values.toList();
  }

  void updateProgress(PdfFileModel? pdfFileModel, double d) {
    if (pdfFileModel == null) {
      return;
    }
    pdfFileModel.progress = d;

    totalBox.put(pdfFileModel.path, pdfFileModel);
  }
}
