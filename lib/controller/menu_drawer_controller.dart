import 'package:get/get.dart';
import 'package:pas_flutter_reynanda/controller/main_menu_controller.dart';

class MenuDrawerController extends GetxController {
  void goToPage(int index) {
    Get.back();
    
    if (Get.isRegistered<MainMenuController>()) {
      Get.find<MainMenuController>().changePage(index);
    }
  }

  void logoutAction() {
    Get.snackbar(
      "Logout Berhasil", 
      "contoh aja",
      snackPosition: SnackPosition.TOP,
    );
  }
}