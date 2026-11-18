import 'package:get/get.dart';
import 'package:pas_flutter_reynanda/models/kuliner_model.dart';

class ListKulinerController extends GetxController {
  RxList<KulinerModel> listKuliner = <KulinerModel>[
    KulinerModel(
      id: 1,
      namaKuliner: "Nasi Goreng Spesial",
      hargaKuliner: 25000,
      deskripsiKuliner: "Nasi goreng bumbu rempah dengan telur mata sapi, ayam suwir, dan kerupuk.",
      gambarKuliner: "https://www.giztop.com/media/catalog/product/cache/97cc1143d2e20f2b0c8ea91aaa12053c/p/m/pms_1790062633.5757078_3.png",
    ),
    KulinerModel(
      id: 2,
      namaKuliner: "Ayam Bakar Madu",
      hargaKuliner: 30000,
      deskripsiKuliner: "Ayam bakar olesan madu murni lengkap dengan sambal terasi dan lalapan.",
      gambarKuliner: "https://www.giztop.com/media/catalog/product/cache/97cc1143d2e20f2b0c8ea91aaa12053c/p/m/pms_1790062633.5757078_3.png",
    ),
    KulinerModel(
      id: 3,
      namaKuliner: "Sate Ayam Madura",
      hargaKuliner: 28000,
      deskripsiKuliner: "10 tusuk sate ayam daging pilihan dengan siraman bumbu kacang kental.",
      gambarKuliner: "https://www.giztop.com/media/catalog/product/cache/97cc1143d2e20f2b0c8ea91aaa12053c/p/m/pms_1790062633.5757078_3.png",
    ),
    KulinerModel(
      id: 4,
      namaKuliner: "Mie Ayam Bakso",
      hargaKuliner: 20000,
      deskripsiKuliner: "Mie kenyal dengan topping ayam kecap, sawi hijau, dan 2 butir bakso sapi.",
      gambarKuliner: "https://www.giztop.com/media/catalog/product/cache/97cc1143d2e20f2b0c8ea91aaa12053c/p/m/pms_1790062633.5757078_3.png",
    ),
    KulinerModel(
      id: 5,
      namaKuliner: "Es Teh Manis Jumbo",
      hargaKuliner: 8000,
      deskripsiKuliner: "Minuman teh melati segar dengan gula asli dan es batu kristal.",
      gambarKuliner: "https://www.giztop.com/media/catalog/product/cache/97cc1143d2e20f2b0c8ea91aaa12053c/p/m/pms_1790062633.5757078_3.png",
    ),
  ].obs; 

  void hapusKuliner(int index) {
    listKuliner.removeAt(index);
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    listKuliner.assignAll([
    ]);
  }
}