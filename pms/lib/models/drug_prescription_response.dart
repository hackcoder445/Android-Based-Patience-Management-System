// To parse this JSON data, do
//
//     final drugPrescriptionResponse = drugPrescriptionResponseFromJson(jsonString);

import 'dart:convert';

List<DrugPrescriptionResponse> drugPrescriptionResponseFromJson(String str) =>
    List<DrugPrescriptionResponse>.from(
        json.decode(str).map((x) => DrugPrescriptionResponse.fromJson(x)));

String drugPrescriptionResponseToJson(List<DrugPrescriptionResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DrugPrescriptionResponse {
  String? drugpresId;
  Prescription? prescription;
  Drug? drug;
  int? qty;
  int? dosage;
  double? price;
  double? total;

  DrugPrescriptionResponse({
    this.drugpresId,
    this.prescription,
    this.drug,
    this.qty,
    this.dosage,
    this.price,
    this.total,
  });

  factory DrugPrescriptionResponse.fromJson(Map<String, dynamic> json) =>
      DrugPrescriptionResponse(
        drugpresId: json["drugpres_id"],
        prescription: json["prescription"] == null
            ? null
            : Prescription.fromJson(json["prescription"]),
        drug: json["drug"] == null ? null : Drug.fromJson(json["drug"]),
        qty: json["qty"],
        dosage: json["dosage"],
        price: json["price"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "drugpres_id": drugpresId,
        "prescription": prescription?.toJson(),
        "drug": drug?.toJson(),
        "qty": qty,
        "dosage": dosage,
        "price": price,
        "total": total,
      };
}

class Drug {
  String? medicineId;
  String? name;
  double? price;

  Drug({
    this.medicineId,
    this.name,
    this.price,
  });

  factory Drug.fromJson(Map<String, dynamic> json) => Drug(
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

class Prescription {
  String? presId;
  String? total;
  Patient? patient;
  DateTime? date;
  bool? paymentMade;
  String? diagnosis;

  Prescription({
    this.presId,
    this.total,
    this.patient,
    this.diagnosis,
    this.date,
    this.paymentMade,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) => Prescription(
        presId: json["pres_id"],
        total: json["total"],
        diagnosis: json["diagnosis"],
        patient:
            json["patient"] == null ? null : Patient.fromJson(json["patient"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        paymentMade: json["payment_made"],
      );

  Map<String, dynamic> toJson() => {
        "pres_id": presId,
        "total": total,
        "diagnosis": diagnosis,
        "patient": patient?.toJson(),
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "payment_made": paymentMade,
      };
}

class Patient {
  String? patientId;
  String? name;
  DateTime? dob;
  String? address;
  String? phone;
  String? gender;
  String? picture;
  String? imgMem;

  Patient({
    this.patientId,
    this.name,
    this.dob,
    this.address,
    this.phone,
    this.gender,
    this.picture,
    this.imgMem,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        patientId: json["patient_id"],
        name: json["name"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        address: json["address"],
        phone: json["phone"],
        gender: json["gender"],
        picture: json["picture"],
        imgMem: json["imgMem"],
      );

  Map<String, dynamic> toJson() => {
        "patient_id": patientId,
        "name": name,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "address": address,
        "phone": phone,
        "gender": gender,
        "picture": picture,
        "imgMem": imgMem,
      };
}
