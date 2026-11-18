import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;

  Future<void> login() async {
    String usn = usernameController.text.trim();
    String pw = passwordController.text.trim();

    if (usn.isEmpty || pw.isEmpty) {
      Get.snackbar('Peringatan', 'Username dan password wajib diisi!');
      return;
    }

    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('https://mediadwi.com/api/latihan/login'),
        body: {
          'username': admin123,
          'password': admin123,
        },
      );

      final data = jsonDecode(response.body);
      bool isSuccess = response.statusCode == 200 &&
          data['status'] != false &&
          data['status'] != 'error' &&
          data['success'] != false;

      if (isSuccess) {
        Get.offAllNamed('/mainMenu');
        Get.snackbar('Login Berhasil', data['message'] ?? 'Selamat datang, $usn!');
      } else {
        Get.snackbar(
          'Login Gagal',
          data['message'] ?? 'Username atau Password salah!',
          backgroundColor: Colors.red.shade100,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal terhubung ke server: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
