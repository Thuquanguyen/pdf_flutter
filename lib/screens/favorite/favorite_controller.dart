import 'package:booklibrary/data/local/favorite_repository.dart';
import 'package:booklibrary/data/local/local_db_manager.dart';
import 'package:booklibrary/screens/app_controller.dart';
import 'package:booklibrary/screens/selected_controller.dart';
import 'package:get/get.dart';

import '../../enum/display_type.dart';
import '../../model/pdf_file_model.dart';

class FavoriteController extends SelectedController {
  static const String eventFavoriteChange = 'eventFavoriteChange';

  FavoriteRepository repository = FavoriteRepository();

  @override
  Future<void> onInit() async {
    super.onInit();
    loadData();
    AppController().initController<FavoriteController>(this);
  }

  Future<void> loadData() async {
    List<PdfFileModel> data = await LocalDbManager().getFavoritePdfList();
    List<PdfFileModel> recentList = await LocalDbManager().getRecentPdfList();

    for (PdfFileModel e in data) {
      e.isFavorite = true;
      for (PdfFileModel f in recentList) {
        if (e.path == f.path) {
          e.progress = f.progress;
          e.currentPage = f.currentPage;
          continue;
        }
      }
    }
    setData(data);
    setSortType(sortBy, sortByType);
  }
}
