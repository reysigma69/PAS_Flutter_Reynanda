// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:project_flutter_pertama/controller/transaction_controller.dart';

// class TransactionPage extends StatelessWidget {
//   TransactionPage({super.key});

//   final controller = Get.put(TransactionController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Transaction'),
//         backgroundColor: Colors.orange,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // INPUT BARANG
//             Text(
//               'Input Barang',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 12),
//             TextField(
//               controller: controller.nameController,
//               decoration: InputDecoration(
//                 labelText: 'Nama Barang',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: controller.priceController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Harga Barang',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: controller.quantityController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'Quantity',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 15),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   controller.addItem(
//                     controller.nameController.text,
//                     double.tryParse(controller.priceController.text) ?? 0,
//                     int.tryParse(controller.quantityController.text) ?? 0,
//                   );

//                   controller.nameController.clear();
//                   controller.priceController.clear();
//                   controller.quantityController.clear();
//                 },
//                 child: Text('Tambah ke Cart'),
//               ),
//             ),

//             SizedBox(height: 25),

            
//             Text(
//               'Keranjang Belanja',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Obx(() {
//               if (controller.items.isEmpty) {
//                 return Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Center(
//                     child: Text('Keranjang masih kosong'),
//                   ),
//                 );
//               }

//               return ListView.builder(
//                 shrinkWrap: true,
//                 // physics: NeverScrollableScrollPhysics(),
//                 itemCount: controller.items.length,
//                 itemBuilder: (context, index) {
//                   final item = controller.items[index];

//                   return Card(
//                     child: ListTile(
//                       title: Text(item.name),
//                       subtitle: Text(
//                         'Rp ${item.price} x ${item.quantity}',
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             onPressed: () {
//                               controller.decrease(index);
//                             },
//                             icon: Icon(Icons.remove),
//                           ),
//                           Text('${item.quantity}'),
//                           IconButton(
//                             onPressed: () {
//                               controller.increase(index);
//                             },
//                             icon: Icon(Icons.add),
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               controller.removeItem(index);
//                             },
//                             icon: Icon(Icons.delete),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),

//             SizedBox(height: 25),

            
//             Text(
//               'Ringkasan Transaksi',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 10),
//             Obx(() {
//               return Card(
//                 color: Colors.orange.shade50,
//                 child: Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Text(
//                         'Total Barang: ${controller.totalQuantity} pcs',
//                       ),
//                       Text(
//                         'Subtotal: Rp ${controller.subtotal.toStringAsFixed(0)}',
//                       ),
//                       Text(
//                         'Diskon (${controller.discountPercent.toStringAsFixed(0)}%): - Rp ${controller.discountAmount.toStringAsFixed(0)}',
//                         style: TextStyle(color: Colors.green.shade700),
//                       ),
//                       Text(
//                         'PPN (${controller.taxRate.toStringAsFixed(0)}%): + Rp ${controller.taxAmount.toStringAsFixed(0)}',
//                       ),
//                       Divider(),
//                       Text(
//                         'Total: Rp ${controller.total.toStringAsFixed(0)}',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }