import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Route - Main Menu')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.offAllNamed('/login');
          },
          child: const Text('Kembali ke Login'),
        ),
      ),
    );
  }
}