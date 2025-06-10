// To parse this JSON data, do
//
//     final prescriptionCreateResponse = prescriptionCreateResponseFromJson(jsonString);

import 'dart:convert';

PrescriptionCreateResponse prescriptionCreateResponseFromJson(String str) => PrescriptionCreateResponse.fromJson(json.decode(str));

String prescriptionCreateResponseToJson(PrescriptionCreateResponse data) => json.encode(data.toJson());

class PrescriptionCreateResponse {
    String? presId;
    DateTime? date;
    String? diagnosis;
    int? total;
    bool? paymentMade;
    String? patient;

    PrescriptionCreateResponse({
        this.presId,
        this.date,
        this.diagnosis,
        this.total,
        this.paymentMade,
        this.patient,
    });

    factory PrescriptionCreateResponse.fromJson(Map<String, dynamic> json) => PrescriptionCreateResponse(
        presId: json["pres_id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        diagnosis: json["diagnosis"],
        total: json["total"],
        paymentMade: json["payment_made"],
        patient: json["patient"],
    );

    Map<String, dynamic> toJson() => {
        "pres_id": presId,
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "diagnosis": diagnosis,
        "total": total,
        "payment_made": paymentMade,
        "patient": patient,
    };
}
