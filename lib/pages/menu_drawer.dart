import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pas_flutter_reynanda/controller/menu_drawer_controller.dart';
import 'package:pas_flutter_reynanda/menu/kuliner_page.dart';

class MenuDrawer extends StatelessWidget {
  MenuDrawer({super.key});

  final controller = Get.put(MenuDrawerController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 10, 169, 4),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.store, size: 35, color: Colors.green),
                  ),
                  Container(height: 10),
                  const Text(
                    'Reynanda Mobile App',
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 20, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home_filled),
                  title: const Text('Home'),
                  onTap: () => controller.goToPage(0),
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Feat'),
                  onTap: () => controller.goToPage(1),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () => controller.goToPage(2),
                ),
                ListTile(
                  leading: const Icon(Icons.food_bank),
                  title: const Text('Kuliner Shop'),
                  onTap: () => controller.goToPage(3)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}