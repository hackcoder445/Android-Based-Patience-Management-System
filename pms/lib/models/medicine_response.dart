// To parse this JSON data, do
//
//     final medicineResponse = medicineResponseFromJson(jsonString);

import 'dart:convert';

List<MedicineResponse> medicineListResponseFromJson(String str) =>
    List<MedicineResponse>.from(
        json.decode(str).map((x) => MedicineResponse.fromJson(x)));

MedicineResponse medicineResponseFromJson(String str) =>
    MedicineResponse.fromJson(json.decode(str));

String medicineResponseToJson(List<MedicineResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MedicineResponse {
  String? medicineId;
  String? name;
  double? price;

  MedicineResponse({
    this.medicineId,
    this.name,
    this.price,
  });

  factory MedicineResponse.fromJson(Map<String, dynamic> json) =>
      MedicineResponse(
        medicineId: json["medicine_id"],
        name: json["name"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "medicine_id": medicineId,
        "name": name,
        "price": price,
      };
}
