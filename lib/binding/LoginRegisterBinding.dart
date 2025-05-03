import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controller/LoginRegisterController.dart';

class LoginRegisterBinding extends Bindings {
  @override
  void dependencies() {
    // 只绑定这个页面专属的 Controller
    Get.lazyPut<LoginRegisterController>(() => LoginRegisterController());
  }
}