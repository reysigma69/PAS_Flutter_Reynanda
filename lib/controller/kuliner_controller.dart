import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pas_flutter_reynanda/models/kuliner_model.dart';

class KulinerController extends GetxController {
  var isLoading = false.obs;
  var listKuliner = <KulinerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchKuliner();
  }

  void fetchKuliner() async {
    try {
      isLoading.value = true;
      final url = Uri.parse("https://fakestoreapi.com/products/category/electronics");

      final response = await http.get(url);

      isLoading.value = false;

      if (response.statusCode == 200) {
        final data = kulinerModelFromJson(response.body);
        listKuliner.assignAll(data);
      } else {
        Get.snackbar("Gagal", "Status code: ${response.statusCode}");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }
}