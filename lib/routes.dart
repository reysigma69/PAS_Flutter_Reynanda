
import 'package:get/get.dart';
import 'package:pas_flutter_reynanda/menu/main_menu_page.dart';

import 'package:pas_flutter_reynanda/pages/detail_kuliner_page.dart';

class Routes {
  static const String mainMenu = "/mainMenu";
  static const String login = "/loginPage";
  static const String detailKuliner = "/detailKuliner";

static final myPages = [
  GetPage(name: mainMenu, page: () => MainMenuPage()),
  GetPage(name: detailKuliner, page: () => DetailKulinerPage()),
  
];

}