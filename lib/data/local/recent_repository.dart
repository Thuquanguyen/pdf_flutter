import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:hive/hive.dart';

class RecentRepository {
  final String name = 'recentBox';

  late Box<PdfFileModel> recentBox;

  static final RecentRepository _singleton = RecentRepository._internal();

  factory RecentRepository() {
    return _singleton;
  }

  Future<void> init() async {
    recentBox = await Hive.openBox<PdfFileModel>(name);
  }

  RecentRepository._internal();

  Future<void> addRecent(PdfFileModel data) async {
    print('addRecent');
    if (recentBox.containsKey(data.path)) {
      return;
    }
    return recentBox.put(data.path, data);
  }

  Future<void> removeRecent(PdfFileModel data) async {
    print('removeRecent');
    if (data.path == null) {
      return;
    }
    return recentBox.delete(data.path);
  }

  Future<List<PdfFileModel>> getListRecent() async {
    return recentBox.values.toList();
  }

  void updateProgress(PdfFileModel? pdfFileModel, double d) {
    if (pdfFileModel == null) {
      return;
    }
    pdfFileModel.progress = d;

    recentBox.put(pdfFileModel.path, pdfFileModel);
  }
}
