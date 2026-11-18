import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pas_flutter_reynanda/menu/feat_page.dart';
import 'package:pas_flutter_reynanda/menu/home_page.dart';
import 'package:pas_flutter_reynanda/menu/profile_page.dart';
import 'package:pas_flutter_reynanda/menu/kuliner_page.dart';

class MainMenuController extends GetxController{
  final RxInt selectedIndex = 0.obs;
  

  void changePage(int index) {
    selectedIndex.value = index;
  }

    List<Widget> listPages = [HomePage(), FeatPage(), ProfilePage(), KulinerPage()];

    void goToPage(int index) {
        selectedIndex.value = index;
        Get.back();
      }
}