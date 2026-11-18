import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pas_flutter_reynanda/controller/kuliner_controller.dart';
import 'package:pas_flutter_reynanda/pages/detail_kuliner_page.dart';

class KulinerPage extends StatelessWidget {
  KulinerPage({super.key});

  final controller = Get.put(KulinerController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 161, 199, 168),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.listKuliner.isEmpty) {
            return const Center(child: Text("Data API kosong"));
          }

          return ListView.builder(
            itemCount: controller.listKuliner.length,
            itemBuilder: (context, index) {
              final kuliner = controller.listKuliner[index];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      offset: const Offset(0, 0),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Get.to(() => DetailKulinerPage(), arguments: kuliner);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 52,
                            height: 52,
                            color: Colors.white,
                            child: Image.network(
                              kuliner.gambarKuliner,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 24, color: Colors.grey),
                            ),
                          ),
                        ),
                        title: Text(
                          kuliner.namaKuliner,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "\$${kuliner.hargaKuliner}",
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}