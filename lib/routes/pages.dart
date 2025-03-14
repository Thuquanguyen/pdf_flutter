import 'package:booklibrary/screens/demo/demo_binding.dart';
import 'package:booklibrary/screens/demo/demo_screen.dart';
import 'package:booklibrary/screens/detail/detail_binding.dart';
import 'package:booklibrary/screens/main/main_binding.dart';
import 'package:booklibrary/screens/main/main_screen.dart';
import 'package:booklibrary/screens/multile_file_selected/multile_file_selected_screen.dart';
import 'package:booklibrary/screens/qr_code/qr_code_binding.dart';
import 'package:booklibrary/screens/qr_code/qr_code_screen.dart';
import 'package:booklibrary/screens/search/search_binding.dart';
import 'package:booklibrary/screens/search/search_screen.dart';
import 'package:booklibrary/screens/splash/splash_binding.dart';
import 'package:booklibrary/screens/splash/splash_screen.dart';
import 'package:get/get.dart';

import '../screens/detail/detail_screen.dart';
import '../screens/multile_file_selected/multiple_selected_binding.dart';
import '../screens/print_preview/pdf_print_preview.dart';

class Pages {
  static List<GetPage> pages() {
    return [
      GetPage(
        name: SplashScreen.routeName,
        page: () => SplashScreen(),
        binding: SplashBinding(),
      ),
      GetPage(
        name: MainScreen.routeName,
        page: () => const MainScreen(),
        binding: MainBinding(),
      ),
      GetPage(
        name: DetailScreen.routeName,
        page: () => DetailScreen(),
        binding: DetailBinding(),
      ),
      GetPage(
        name: QrCodeScreen.routeName,
        page: () => QrCodeScreen(),
        binding: QrCodeBinding(),
      ),
      GetPage(
        name: SearchScreen.routeName,
        page: () => const SearchScreen(),
        binding: SearchBinding(),
      ),
      GetPage(
        name: DemoScreen.routeName,
        page: () => DemoScreen(),
        binding: DemoBinding(),
      ),
      GetPage(
        name: MultipleFileSelectedScreen.routeName,
        page: () => const MultipleFileSelectedScreen(),
        binding: MultipleSelectedBinding(),
      ),
      GetPage(
        name: PdfPrintPreviewScreen.routeName,
        page: () => const PdfPrintPreviewScreen(),
      ),
    ];
  }
}
