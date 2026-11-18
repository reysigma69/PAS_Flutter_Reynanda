import 'dart:convert';

List<KulinerModel> kulinerModelFromJson(String str) =>
    List<KulinerModel>.from(json.decode(str).map((x) => KulinerModel.fromJson(x)));

class KulinerModel {
  final int id;
  final String namaKuliner;
  final double hargaKuliner;
  final String deskripsiKuliner;
  final String gambarKuliner;

  KulinerModel({
    required this.id,
    required this.namaKuliner,
    required this.hargaKuliner,
    required this.deskripsiKuliner,
    required this.gambarKuliner,
  });

  factory KulinerModel.fromJson(Map<String, dynamic> json) => KulinerModel(
        id: json["id"],
        namaKuliner: json["Nama Kuliner"],
        hargaKuliner: json["Harga Kuliner"],
        deskripsiKuliner: json["Deskripsi Kuliner"] ?? "",
        gambarKuliner: json["Gambar Kuliner"] ?? "",
      );
}


// class KulinerModel {
//   final int id;
//   final String namaKuliner;
//   final double hargaKuliner;
//   final String deskripsiKuliner;
//   final String gambarKuliner;

//   KulinerModel({
//     required this.id,
//     required this.namaKuliner,
//     required this.hargaKuliner,
//     required this.deskripsiKuliner,
//     required this.gambarKuliner,
//   });
// }