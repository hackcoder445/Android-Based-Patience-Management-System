// To parse this JSON data, do
//
//     final patientListResponse = patientListResponseFromJson(jsonString);

import 'dart:convert';

List<PatientListResponse> patientListResponseFromJson(String str) =>
    List<PatientListResponse>.from(
        json.decode(str).map((x) => PatientListResponse.fromJson(x)));

PatientListResponse patientResponseFromJson(String str) =>
    PatientListResponse.fromJson(json.decode(str));

String patientListResponseToJson(List<PatientListResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PatientListResponse {
  String? patientId;
  String? name;
  DateTime? dob;
  String? address;
  String? phone;
  String? gender;
  String? picture;
  String? imgMem;

  PatientListResponse({
    this.patientId,
    this.name,
    this.dob,
    this.address,
    this.phone,
    this.gender,
    this.picture,
    this.imgMem,
  });

  factory PatientListResponse.fromJson(Map<String, dynamic> json) =>
      PatientListResponse(
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
