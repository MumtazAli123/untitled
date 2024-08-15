import 'package:get/get.dart';

import '../controllers/tab_screens_controller.dart';

class TabScreensBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabScreensController>(
      () => TabScreensController(),
    );
  }
}
