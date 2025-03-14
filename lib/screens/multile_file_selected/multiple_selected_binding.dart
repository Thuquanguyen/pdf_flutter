import 'package:get/get.dart';

import 'multiple_selected_controller.dart';

class MultipleSelectedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MultipleSelectedController());
  }
}
