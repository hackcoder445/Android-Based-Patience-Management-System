import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms/controllers/payment_controller.dart';
import 'package:pms/controllers/report_controllers.dart';
import 'package:pms/models/drug_prescription_response.dart';
import 'package:pms/models/login_response.dart';
import 'package:pms/models/medicine_response.dart';
import 'package:pms/models/patient_list_response.dart';
import 'package:pms/models/prescription_create_response.dart';
import 'package:pms/models/visitation_report_response.dart';
import 'package:pms/services/urls.dart';
import 'package:http/http.dart' as http;
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultText.dart';

import '../main.dart';

class RemoteServices {
  final controller = Get.put(PaymentController());

  static Future<LoginResponse?> login(
      String? username, String? password) async {
    try {
      http.Response response = await http
          .post(loginUrl, body: {'username': username, 'password': password});
      var responseData = jsonDecode(response.body);
      if (responseData != null) {
        if (responseData['key'] != null) {
          sharedPreferences.setString('token', responseData['key']);
          // UserDetailsResponse? userDetail = await RemoteServices.userDetails();
          Get.offAllNamed('/dashboard');
        } else if (responseData['non_field_errors'] != null) {
          
          // RemoteServices.controller.isClicked.value = false;
          Get.showSnackbar(Constants.customSnackBar(
              message: "${responseData['non_field_errors']}", tag: false));
        }
      }
    } catch (e) {
      // RemoteServices.controller.isClicked.value = false;

      Get.showSnackbar(Constants.customSnackBar(
          message: "An error occurred: $e", tag: false));
    }
    return null;
  }

  static Future<List<PatientListResponse>?>? patientList() async {
    try {
      http.Response response = await http.get(patientListUrl, headers: {
        'Authorization': "Token ${sharedPreferences.getString('token')}"
      });
      if (response.statusCode == 200) {
        return patientListResponseFromJson(response.body);
      } else {
        throw Exception("Failed to get patients");
      }
    } catch (e) {
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }

  static Future<PatientListResponse?> addPatient(String? name, String? address,
      String? phone, String? gender, String? dob, File? picture) async {
    try {
      var headers = {
        'Authorization': 'Token ${sharedPreferences.getString('token')}',
        "content-type": "multipart/form-data"
      };
      var request = http.MultipartRequest('POST', patientListUrl);
      request.fields.addAll({
        'name': name.toString(),
        'address': address.toString(),
        'dob': dob.toString(),
        'phone': phone.toString(),
        'gender': gender.toString(),
      });
      request.files
          .add(await http.MultipartFile.fromPath('picture', picture!.path));

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        Get.defaultDialog(
            title: "",
            content: Column(
              children: const [
                Icon(
                  Icons.check_circle,
                  color: Constants.secondaryColor,
                  size: 120,
                ),
                DefaultText(text: "Patient Successfully Added")
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Get.close(2),
                  child: const DefaultText(
                    text: "Okay",
                    size: 18.0,
                  ))
            ]);
      } else {
        print(await response.stream.bytesToString());
        // throw Exception("An error occurred: ");
      }
    } catch (e) {
      print(e);
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }

  static Future<PatientListResponse?> patientDetails(String id) async {
    try {
      http.Response response = await http.get(patientDetailUrl(id), headers: {
        'Authorization': "Token ${sharedPreferences.getString('token')}"
      });
      if (response.statusCode == 200) {
        print("response.body");
        print("${patientResponseFromJson(response.body)}");
        return patientResponseFromJson(response.body);
      }
    } catch (e) {
      print(e);
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }

  static Future<MedicineResponse?> addMedicine(
      {String? name, double? price}) async {
    try {
      http.Response response = await http.post(medicineListUrl,
          body: jsonEncode({'name': name, 'price': price}),
          headers: {
            'content-type': 'application/json; charset=UTF-8',
            'Authorization': "Token ${sharedPreferences.getString('token')}"
          });
      if (response.statusCode == 201) {
        Get.showSnackbar(Constants.customSnackBar(
            message: "Drug Added Successfully", tag: true));
        Get.close(1);
      } else {}
    } catch (e) {
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }

  static Future<List<MedicineResponse>?>? medicineList() async {
    try {
      http.Response response = await http.get(medicineListUrl, headers: {
        'Authorization': "Token ${sharedPreferences.getString('token')}"
      });
      if (response.statusCode == 200) {
        return medicineListResponseFromJson(response.body);
      } else {
        throw Exception("Failed to get medicine");
      }
    } catch (e) {
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }

  static Future<MedicineResponse?> medicineDetails(String id) async {
    try {
      http.Response response = await http.get(medicineDetailUrl(id), headers: {
        'Authorization': "Token ${sharedPreferences.getString('token')}"
      });
      if (response.statusCode == 200) {
        return medicineResponseFromJson(response.body);
      }
    } catch (e) {
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }

  static Future<MedicineResponse?> medicineUpdate(String id,
      {String? name, String? price}) async {
    try {
      http.Response response = await http.put(medicineDetailUrl(id), body: {
        'name': name,
        'price': price
      }, headers: {
        'Authorization': "Token ${sharedPreferences.getString('token')}"
      });
      if (response.statusCode == 200) {
        Get.showSnackbar(
            Constants.customSnackBar(message: "Medicine Updated", tag: true));
        Get.close(2);
        return medicineResponseFromJson(response.body);
      } else {
        print(response.body);
      }
    } catch (e) {
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }

  static Future<PrescriptionCreateResponse?> prescribeDrugs(
      {required List<Map<String, dynamic>>? drugsPrescribe,
      required String patient,
      bool? payment,
      required String diagnosis}) async {
    try {
      http.Response response = await http.post(prescribeDrugUrl,
          body: jsonEncode({
            'patient': patient,
            'drug_prescribed': drugsPrescribe,
            'diagnosis': diagnosis,
            'payment_made': true
          }),
          headers: {
            'content-type': 'application/json; charset=UTF-8',
            'Authorization': "Token ${sharedPreferences.getString('token')}"
          });

      if (response.statusCode == 201) {
        Get.showSnackbar(
            Constants.customSnackBar(message: "Prescription Saved", tag: true));
        var data = jsonDecode(response.body);
        RemoteServices().controller.prescription_id.value = data['pres_id'];
        return prescriptionCreateResponseFromJson(response.body);
      } else {
        print(jsonDecode(response.body));
        throw Exception("An error occurred");
      }
    } catch (e) {
      // Get.showSnackbar(
      //     Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }

  static Future<List<DrugPrescriptionResponse>?>? getDrugInvoice() async {
    try {
      http.Response response = await http.get(
          drugInvoiceUrl(RemoteServices().controller.prescription_id.value),
          headers: {
            'Authorization': "Token ${sharedPreferences.getString('token')}"
          });
      if (response.statusCode == 200) {
        // print(response.body);
        RemoteServices().controller.drugInvoice.value =
            drugPrescriptionResponseFromJson(response.body);
        return drugPrescriptionResponseFromJson(response.body);
      } else {
        print(response.body);
        throw Exception("An error occurred");
      }
    } catch (e) {
      // print(e);
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }

  static Future<List<DrugPrescriptionResponse>?>? getPrescribedDrugInvoice(
      String id) async {
    try {
      http.Response response = await http.get(drugInvoiceUrl(id), headers: {
        'Authorization': "Token ${sharedPreferences.getString('token')}"
      });
      if (response.statusCode == 200) {
        // print(response.body);

        return drugPrescriptionResponseFromJson(response.body);
      } else {
        print(response.body);
        throw Exception("An error occurred");
      }
    } catch (e) {
      // print(e);
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }

  static Future<List<DrugPrescriptionResponse>?>? getPrescribedData(
      String? id) async {
    try {
      http.Response response = await http.get(prescribedDrugUrl(id), headers: {
        'Authorization': "Token ${sharedPreferences.getString('token')}"
      });
      if (response.statusCode == 200) {
        // print(response.body);

        return drugPrescriptionResponseFromJson(response.body);
      } else {
        print(response.body);
        throw Exception("An error occurred");
      }
    } catch (e) {
      // print(e);
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }

  static Future<List<DrugPrescriptionResponse>?>? getScannedDrugInvoice(
      endPoint) async {
    try {
      http.Response response = await http.get(Uri.parse("$endPoint"), headers: {
        'Authorization': "Token ${sharedPreferences.getString('token')}"
      });
      print("end: $endPoint");
      if (response.statusCode == 200) {
        print("res-${response.body}");

        return drugPrescriptionResponseFromJson(response.body);
      } else {
        print(response.body);
        throw Exception("An error occurred");
      }
    } catch (e) {
      print(e);
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
  }

  static Future<List<VisitationReportResponse>?> generateVisitReport(
      {String? from, String? to}) async {
    final reportController = Get.put(ReportController());

    try {
      http.Response response = await http.get(
          Uri.parse("$baseUrl/api/visitation-report/?from=$from&to=$to"),
          headers: {
            'Authorization': "Token ${sharedPreferences.getString('token')}"
          });

      if (response.statusCode == 200) {
        // print(response.body);

        return visitationReportResponseFromJson(response.body);
      } else {
        // print(response.body);
        throw Exception("Failed to get report");
      }
    } catch (e) {
      print(e);
      Get.showSnackbar(
          Constants.customSnackBar(message: "Server Error: $e", tag: false));
    }
    // return null;
  }
}
