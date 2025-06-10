// To parse this JSON data, do
//
//     final visitationReportResponse = visitationReportResponseFromJson(jsonString);

import 'dart:convert';

List<VisitationReportResponse> visitationReportResponseFromJson(String str) =>
    List<VisitationReportResponse>.from(
        json.decode(str).map((x) => VisitationReportResponse.fromJson(x)));

String visitationReportResponseToJson(List<VisitationReportResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VisitationReportResponse {
  String? presId;
  String? total;
  Patient? patient;
  DateTime? date;
  String? diagnosis;
  bool? paymentMade;

  VisitationReportResponse({
    this.presId,
    this.total,
    this.patient,
    this.date,
    this.diagnosis,
    this.paymentMade,
  });

  factory VisitationReportResponse.fromJson(Map<String, dynamic> json) =>
      VisitationReportResponse(
        presId: json["pres_id"],
        total: json["total"],
        patient: Patient.fromJson(json["patient"]),
        date: DateTime.parse(json["date"]),
        diagnosis: json["diagnosis"],
        paymentMade: json["payment_made"],
      );

  Map<String, dynamic> toJson() => {
        "pres_id": presId,
        "total": total,
        "patient": patient!.toJson(),
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "diagnosis": diagnosis,
        "payment_made": paymentMade,
      };
}

class Patient {
  String patientId;
  String name;
  DateTime dob;
  String address;
  String phone;
  String gender;
  String picture;
  String imgMem;

  Patient({
    required this.patientId,
    required this.name,
    required this.dob,
    required this.address,
    required this.phone,
    required this.gender,
    required this.picture,
    required this.imgMem,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        patientId: json["patient_id"],
        name: json["name"],
        dob: DateTime.parse(json["dob"]),
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
            "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "address": address,
        "phone": phone,
        "gender": gender,
        "picture": picture,
        "imgMem": imgMem,
      };
}
