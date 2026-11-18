import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pas_flutter_reynanda/controller/feat_controller.dart';

class FeatPage extends StatelessWidget {
  FeatPage({super.key});

  final FeatController featController = Get.put(FeatController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (featController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (featController.teamList.isEmpty) {
        return const Center(
          child: Text('Data klub tidak ditemukan'),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: featController.teamList.length,
        itemBuilder: (context, index) {
          final team = featController.teamList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    child: team.strBadge.isNotEmpty
                        ? Image.network(
                            team.strBadge,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.shield, size: 40),
                          )
                        : const Icon(Icons.shield, size: 40),
                  ),
                  Container(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          team.strTeam,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.stadium,
                              size: 16,
                              color: Colors.grey,
                            ),
                            Container(width: 6),
                            Expanded(
                              child: Text(
                                team.strStadium,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
