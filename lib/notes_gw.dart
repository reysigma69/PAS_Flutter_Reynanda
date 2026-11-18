// ============================================================================
// CHEAT SHEET FULL PAS FLUTTER - XI PPLG (NO COPILOT EDITION)
// ============================================================================
// [LANGKAH 0: SETUP AWAL DI TERMINAL VSC]
// 1. flutter pub add get http
// 2. git add . && git commit -m "init project" && git push
// 3. Tambah izin internet di android/app/src/main/AndroidManifest.xml (di atas <application>):
//    <uses-permission android:name="android.permission.INTERNET"/>
// ============================================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// ============================================================================
// FITUR 1: MAIN APP (WAJIB PAKAI GetMaterialApp BIAR Get.to & snackbar JALAN)
// ============================================================================
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PAS Flutter Reynanda',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

// ============================================================================
// FITUR 2: MODEL UNIVERSAL (BISA BUAT DATA LOKAL MAUPUN PARSING JSON DARI API)
// ============================================================================
// Catatan adaptasi tema soal:
// - E-Commerce -> Produk (title, price, description, category, image)
// - Kuliner    -> Menu Makanan/Minuman (tinggal ganti teks UI jadi Menu)
// - Ticketing  -> Tiket Wisata/Konser (tinggal ganti Qty jadi Jumlah Tiket)
class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? 'Tanpa Nama',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? 'Tidak ada deskripsi',
      category: json['category'] ?? 'Umum',
      image: json['thumbnail'] ?? json['image'] ?? '',
    );
  }
}

// ============================================================================
// FITUR 3: AUTH CONTROLLER (LOGIN LOKAL admin123 + OPSI LOGIN API)
// ============================================================================
class AuthController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;

  // Login Lokal (Default sesuai project lama: admin123)
  void loginLokal() {
    String usn = usernameController.text.trim();
    String pw = passwordController.text.trim();

    if ((usn == 'admin123' || usn == 'admin') && pw == 'admin123') {
      Get.offAll(() => MainMenuPage());
      Get.snackbar('Login Berhasil', 'Selamat datang, $usn!');
    } else {
      Get.snackbar('Login Gagal', 'Username atau Password salah!');
    }
  }

  // Cadangan kalau soal minta login tembak API POST
  Future<void> loginApi() async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': usernameController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        Get.offAll(() => MainMenuPage());
        Get.snackbar('Login Berhasil', 'Berhasil masuk via API');
      } else {
        Get.snackbar('Login Gagal', 'Cek kembali akun Anda');
      }
    } catch (e) {
      Get.snackbar('Error', 'Koneksi bermasalah: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

// ============================================================================
// FITUR 4: PRODUCT & NAVIGATION CONTROLLER (DRAWER + LIST LOKAL + GET API)
// ============================================================================
class ProductController extends GetxController {
  // Index halaman aktif dari Sidebar (0 = Lokal, 1 = API)
  var selectedMenuIndex = 0.obs;
  var isLoading = false.obs;

  // Data Hardcoded Lokal (Harga 100.000 pas buat ngetes rumus MTK Pak Aji)
  var localProducts = <ProductModel>[
    ProductModel(
      id: 1,
      title: 'Paket Item Utama A',
      price: 100000,
      description: 'Deskripsi lengkap item A untuk simulasi transaksi PAS.',
      category: 'Reguler',
      image: '',
    ),
    ProductModel(
      id: 2,
      title: 'Paket Item Spesial B',
      price: 250000,
      description: 'Deskripsi lengkap item B dengan fitur dan kualitas terbaik.',
      category: 'VIP',
      image: '',
    ),
    ProductModel(
      id: 3,
      title: 'Paket Item Hemat C',
      price: 50000,
      description: 'Deskripsi lengkap item C harga terjangkau.',
      category: 'Hemat',
      image: '',
    ),
  ].obs;

  // Data dari API
  var apiProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchApiProducts();
  }

  // Ganti halaman lewat Sidebar Drawer lalu tutup drawer otomatis
  void changeMenu(int index) {
    selectedMenuIndex.value = index;
    Get.back();
  }

  // Fetch Data API (HTTP GET)
  Future<void> fetchApiProducts() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('https://dummyjson.com/products'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // CATATAN: Kalau JSON dari Pak Aji langsung List [...], ganti baris bawah jadi:
        // final List listData = jsonDecode(response.body);
        final List listData = data['products'];
        apiProducts.value =
            listData.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        Get.snackbar('Error API', 'Gagal memuat data (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

// ============================================================================
// FITUR 5: TRANSAKSI CONTROLLER (COLLAB MAPEL MTK: QTY, DISKON, PPN, KEMBALIAN)
// ============================================================================
// Rumus MTK:
// - Subtotal       = Harga Satuan * Qty
// - Nominal Diskon = Subtotal * (Diskon% / 100)
// - Setelah Diskon = Subtotal - Nominal Diskon
// - Nominal PPN    = Setelah Diskon * (PPN% / 100)
// - Total Akhir    = Setelah Diskon + Nominal PPN
class TransaksiController extends GetxController {
  var hargaSatuan = 0.0.obs;
  var qty = 1.obs;
  var diskonPersen = 0.0.obs;
  var ppnPersen = 0.0.obs;
  var uangBayar = 0.0.obs;

  final diskonTextController = TextEditingController(text: '0');
  final ppnTextController = TextEditingController(text: '0');
  final bayarTextController = TextEditingController();

  // Dipanggil setiap kali item diklik sebelum pindah ke DetailTransaksiPage
  void initProduk(double harga) {
    hargaSatuan.value = harga;
    qty.value = 1;
    // CATATAN: Kalau diskon/PPN di soal hardcoded (tanpa input), isi angkanya di sini:
    // diskonPersen.value = 10;
    // ppnPersen.value = 5;
    diskonPersen.value = 0;
    ppnPersen.value = 0;
    uangBayar.value = 0;
    diskonTextController.text = '0';
    ppnTextController.text = '0';
    bayarTextController.clear();
  }

  void tambahQty() => qty.value++;

  void kurangQty() {
    if (qty.value > 1) qty.value--;
  }

  void updateDiskon(String val) {
    double parsed = double.tryParse(val) ?? 0;
    if (parsed < 0) parsed = 0;
    if (parsed > 100) parsed = 100;
    diskonPersen.value = parsed;
  }

  void updatePpn(String val) {
    double parsed = double.tryParse(val) ?? 0;
    if (parsed < 0) parsed = 0;
    ppnPersen.value = parsed;
  }

  void updateBayar(String val) {
    uangBayar.value = double.tryParse(val) ?? 0;
  }

  // Getter Perhitungan Otomatis
  double get subtotal => hargaSatuan.value * qty.value;
  double get nominalDiskon => subtotal * (diskonPersen.value / 100);
  double get setelahDiskon => subtotal - nominalDiskon;
  // CATATAN: Kalau PPN dihitung dari subtotal sebelum diskon, ganti jadi: subtotal * (ppnPersen.value / 100)
  double get nominalPpn => setelahDiskon * (ppnPersen.value / 100);
  double get totalAkhir => setelahDiskon + nominalPpn;
  double get kembalian => uangBayar.value - totalAkhir;

  // Helper Format Rupiah Manual (Tanpa perlu install package intl)
  String formatRupiah(double number) {
    int value = number.round();
    String str = value.toString();
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      result = str[i] + result;
      count++;
      if (count % 3 == 0 && i != 0 && str[i - 1] != '-') {
        result = '.$result';
      }
    }
    return 'Rp $result';
  }
}

// ============================================================================
// FITUR 6: LOGIN PAGE (STATELESS WIDGET + CONTAINER SPASI, TANPA OBSCURETEXT)
// ============================================================================
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Aplikasi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.store, size: 80, color: Colors.blue),
            Container(height: 20),
            TextField(
              controller: authController.usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            Container(height: 15),
            TextField(
              controller: authController.passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            Container(height: 25),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  authController.loginLokal();
                },
                child: const Text('LOGIN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FITUR 7: MENU DRAWER / SIDEBAR (PENGGANTI BOTTOM NAVBAR)
// ============================================================================
class MenuDrawer extends StatelessWidget {
  MenuDrawer({super.key});

  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.account_circle, size: 50, color: Colors.white),
                Text(
                  'Admin PAS Flutter',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  'XI PPLG - SMK RUS',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Data Lokal (Controller)'),
            onTap: () {
              productController.changeMenu(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_download),
            title: const Text('Data Katalog (API)'),
            onTap: () {
              productController.changeMenu(1);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Get.offAll(() => LoginPage());
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// FITUR 8: MAIN MENU PAGE (TANPA BOTTOM NAVBAR, PAKAI DRAWER SIDEBAR)
// ============================================================================
class MainMenuPage extends StatelessWidget {
  MainMenuPage({super.key});

  final ProductController productController = Get.put(ProductController());
  final TransaksiController transaksiController = Get.put(TransaksiController());

  final List<Widget> pages = [
    HomeLocalPage(),
    ApiProductPage(),
  ];

  final List<String> titles = [
    'Menu Utama (Data Lokal)',
    'Katalog Data API',
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int index = productController.selectedMenuIndex.value;
      return Scaffold(
        appBar: AppBar(
          title: Text(titles[index]),
        ),
        drawer: MenuDrawer(),
        body: pages[index],
      );
    });
  }
}

// ============================================================================
// FITUR 9: HALAMAN LIST DATA LOKAL (HARDCODED CONTROLLER -> KLIK KE DETAIL)
// ============================================================================
class HomeLocalPage extends StatelessWidget {
  HomeLocalPage({super.key});

  final ProductController productController = Get.find<ProductController>();
  final TransaksiController transaksiController = Get.find<TransaksiController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: productController.localProducts.length,
        itemBuilder: (context, index) {
          final item = productController.localProducts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                transaksiController.initProduk(item.price);
                Get.to(() => DetailTransaksiPage(product: item));
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      color: Colors.blue.shade100,
                      child: const Icon(Icons.shopping_bag, color: Colors.blue),
                    ),
                    Container(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(height: 4),
                          Text(
                            item.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Container(height: 6),
                          Text(
                            transaksiController.formatRupiah(item.price),
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

// ============================================================================
// FITUR 10: HALAMAN LIST DATA API (DARI SIDEBAR -> KLIK KE DETAIL)
// ============================================================================
class ApiProductPage extends StatelessWidget {
  ApiProductPage({super.key});

  final ProductController productController = Get.find<ProductController>();
  final TransaksiController transaksiController = Get.find<TransaksiController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (productController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (productController.apiProducts.isEmpty) {
        return const Center(child: Text('Data API kosong'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: productController.apiProducts.length,
        itemBuilder: (context, index) {
          final item = productController.apiProducts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                transaksiController.initProduk(item.price);
                Get.to(() => DetailTransaksiPage(product: item));
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade200,
                      child: item.image.isNotEmpty
                          ? Image.network(item.image, fit: BoxFit.cover)
                          : const Icon(Icons.image),
                    ),
                    Container(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(height: 4),
                          Text(
                            item.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Container(height: 6),
                          Text(
                            transaksiController.formatRupiah(item.price),
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

// ============================================================================
// FITUR 11: DETAIL PRODUK & PERHITUNGAN TRANSAKSI MTK (DISKON + PPN + BAYAR)
// ============================================================================
class DetailTransaksiPage extends StatelessWidget {
  final ProductModel product;

  DetailTransaksiPage({super.key, required this.product});

  final TransaksiController transaksiController = Get.find<TransaksiController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail & Transaksi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 180,
              color: Colors.blue.shade50,
              child: product.image.isNotEmpty
                  ? Image.network(product.image, fit: BoxFit.contain)
                  : const Icon(Icons.shopping_cart, size: 80, color: Colors.blue),
            ),
            Container(height: 16),
            Text(
              product.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Container(height: 6),
            Text(
              'Kategori: ${product.category}',
              style: const TextStyle(color: Colors.blueGrey),
            ),
            Container(height: 8),
            Text(
              transaksiController.formatRupiah(product.price),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Container(height: 12),
            Text(product.description),
            Container(height: 20),
            const Divider(),
            const Text(
              'Perhitungan Transaksi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(height: 12),

            // Input Jumlah Beli (Qty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Jumlah Beli (Qty):', style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => transaksiController.kurangQty(),
                      child: const Text('-'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Obx(() => Text(
                            '${transaksiController.qty.value}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    ElevatedButton(
                      onPressed: () => transaksiController.tambahQty(),
                      child: const Text('+'),
                    ),
                  ],
                ),
              ],
            ),
            Container(height: 12),

            // Input Diskon (%)
            TextField(
              controller: transaksiController.diskonTextController,
              keyboardType: TextInputType.number,
              onChanged: (val) => transaksiController.updateDiskon(val),
              decoration: const InputDecoration(
                labelText: 'Diskon (%)',
                border: OutlineInputBorder(),
                suffixText: '%',
              ),
            ),
            Container(height: 12),

            // Input PPN (%)
            TextField(
              controller: transaksiController.ppnTextController,
              keyboardType: TextInputType.number,
              onChanged: (val) => transaksiController.updatePpn(val),
              decoration: const InputDecoration(
                labelText: 'PPN / Pajak (%)',
                border: OutlineInputBorder(),
                suffixText: '%',
              ),
            ),
            Container(height: 12),

            // Input Uang Bayar (Opsional untuk hitung kembalian)
            TextField(
              controller: transaksiController.bayarTextController,
              keyboardType: TextInputType.number,
              onChanged: (val) => transaksiController.updateBayar(val),
              decoration: const InputDecoration(
                labelText: 'Uang Bayar (Opsional)',
                border: OutlineInputBorder(),
                prefixText: 'Rp ',
              ),
            ),
            Container(height: 16),

            // Kotak Rincian Struk Real-Time
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subtotal: ${transaksiController.formatRupiah(transaksiController.subtotal)}',
                    ),
                    Container(height: 4),
                    Text(
                      'Potongan Diskon (${transaksiController.diskonPersen.value.toStringAsFixed(0)}%): - ${transaksiController.formatRupiah(transaksiController.nominalDiskon)}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    Container(height: 4),
                    Text(
                      'PPN (${transaksiController.ppnPersen.value.toStringAsFixed(0)}%): + ${transaksiController.formatRupiah(transaksiController.nominalPpn)}',
                      style: const TextStyle(color: Colors.orange),
                    ),
                    const Divider(),
                    Text(
                      'TOTAL BAYAR: ${transaksiController.formatRupiah(transaksiController.totalAkhir)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    if (transaksiController.uangBayar.value > 0) ...[
                      Container(height: 6),
                      Text(
                        'Kembalian: ${transaksiController.formatRupiah(transaksiController.kembalian)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: transaksiController.kembalian >= 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ),
            Container(height: 16),

            // Tombol Konfirmasi Transaksi
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    'Transaksi Selesai',
                    'Total yang harus dibayar: ${transaksiController.formatRupiah(transaksiController.totalAkhir)}',
                  );
                },
                child: const Text('PROSES TRANSAKSI'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}