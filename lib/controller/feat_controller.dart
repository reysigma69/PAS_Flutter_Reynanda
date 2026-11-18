import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/team_model.dart';

class FeatController extends GetxController {
  var isLoading = false.obs;
  var teamList = <Team>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeams();
  }

  Future<void> fetchTeams() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(
          'https://www.thesportsdb.com/api/v1/json/123/search_all_teams.php?l=English%20Premier%20League',
        ),
      );

      if (response.statusCode == 200) {
        final result = premierLeagueModelFromJson(response.body);
        teamList.value = result.teams;
      } else {
        Get.snackbar('Error API', 'Gagal memuat data (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data klub: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
