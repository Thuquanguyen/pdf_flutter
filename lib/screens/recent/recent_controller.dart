import 'package:booklibrary/data/local/local_db_manager.dart';
import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:booklibrary/screens/app_controller.dart';
import 'package:booklibrary/screens/selected_controller.dart';
import 'package:get/get.dart';
import '../detail/detail_screen.dart';

class RecentController extends SelectedController {
  static const String eventRecentChange = 'eventRecentChange';

  @override
  Future<void> onInit() async {
    super.onInit();
    loadData();
    AppController().initController<RecentController>(this);
  }

  Future<void> loadData() async {
    List<PdfFileModel> data = await LocalDbManager().getRecentPdfList();
    List<PdfFileModel> favoriteList =
        await LocalDbManager().getFavoritePdfList();

    for (PdfFileModel e in data) {
      bool tmp = false;
      for (PdfFileModel f in favoriteList) {
        if (e.path == f.path) {
          e.isFavorite = true;
          tmp = true;
          break;
        }
      }
      if (tmp == false) {
        e.isFavorite = false;
      }
    }
    setData(data);
    setSortType(sortBy, sortByType);
  }

  Future<void> gotoDetailScreen(PdfFileModel pdfFileModel) async {
    Get.toNamed(
      DetailScreen.routeName,
      arguments: pdfFileModel,
    );
  }
}
