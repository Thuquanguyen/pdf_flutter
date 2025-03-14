import 'package:get/get.dart';

import 'recent_controller.dart';

class RecentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecentController());
  }
}
