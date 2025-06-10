import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pms/models/drug_list.dart';
import 'package:pms/models/medicine_response.dart';
import 'package:pms/models/patient_list_response.dart';
import 'package:pms/services/remote_services.dart';
import 'package:pms/utils/constants.dart';

class PrescriptionController extends GetxController {
  Rx<DateTime> pickedDate = DateTime.now().obs;
  Rx<TextEditingController> visit_date = TextEditingController().obs;
  RxString? medicine = ''.obs;
  RxString? selectedMedicine = ''.obs;
  RxString? patient = ''.obs;
  RxString? medicineId = ''.obs;
  RxDouble? price = 0.0.obs;
  Rx<TextEditingController> diagnosis = TextEditingController().obs;
  Rx<TextEditingController> qty = TextEditingController().obs;
  Rx<TextEditingController> dosage = TextEditingController().obs;
  RxString dropdownvalue = ''.obs;
  Rx<bool> isClicked = false.obs;
  RxList drugList = <DrugList>[].obs;
  String publicKey = 'pk_test_967fd6ae89cd3a4c7b03b27c93083beab0329110';
  RxString message = ''.obs;
  RxDouble total = 0.0.obs;
  RxDouble gtotal = 0.0.obs;
  RxList<PatientListResponse> patients = <PatientListResponse>[].obs;
  RxList<MedicineResponse> medicines = <MedicineResponse>[].obs;

  RxList<Map<String, dynamic>> drugPrescribed = <Map<String, dynamic>>[].obs;

  final plugin = PaystackPlugin();

  @override
  void onInit() async {
    super.onInit();
    plugin.initialize(publicKey: publicKey);
    await patientList();
    await medicineList();
  }

  patientList() async {
    List<PatientListResponse>? patientList = await RemoteServices.patientList();
    if (patientList!.isNotEmpty) {
      patients.value = patientList;
    }
  }

  medicineList() async {
    List<MedicineResponse>? medicineList = await RemoteServices.medicineList();
    if (medicineList!.isNotEmpty) {
      medicines.value = medicineList;
    }
  }

  void makePayment(context) async {
    Charge charge = Charge()
      ..amount = calculateTotal(drugList).toInt() * 100
      ..reference = 'ref_${DateTime.now()}'
      ..email = 'ademolabello519@gmail.com'
      // ..accessCode = '+234'
      ..currency = 'NGN';

    CheckoutResponse response = await plugin.checkout(context,
        method: CheckoutMethod.card, charge: charge);

    if (response.status == true) {
      message.value = 'Payment was successful. Ref: ${response.reference}';
      Get.toNamed('/payment_success', arguments: {
        'message': message.value,
        'invoice_number': response.reference,
        'drug_prescribed': drugPrescribed,
        'patientId': patient!.value,
        'diagnosis': diagnosis.value.text,
      });
    } else {
      print(response.message);
    }

    isClicked.value = false;
  }

  cir() {
    return Constants.circ(isClicked, "Proceed to Payment");
  }

  Future<void> pickDate(context) async {
    var selectedDate = await showDatePicker(
      context: context,
      initialDate: pickedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                    primary: Constants.primaryColor,
                    onPrimary: Constants.altColor,
                    onSurface: Constants.secondaryColor)),
            child: child!);
      },
    );

    if (selectedDate != null) {
      pickedDate.value = selectedDate;
      visit_date.value.text = DateFormat("yyyy-MM-dd").format(pickedDate.value);
    }
  }

  populateTable() {
    drugList.add(DrugList(
        drugId: medicineId!.value,
        name: medicine!.value,
        price: price!.value,
        total: double.parse(qty.value.text) * price!.value,
        qty: qty.value.text,
        dosage: dosage.value.text));

    // print(drugList[0].drugId);
    selectedMedicine!.value = medicine!.value;

    Map<String, dynamic> item = {
      "drug": medicineId!.value,
      "qty": qty.value.text,
      "dosage": dosage.value.text,
      "price": price!.value,
      "total": int.parse(qty.value.text) * price!.value,
    };

    drugPrescribed.add(item);
    // print(drugPrescribed);
  }

  double calculateTotal(RxList drugList) {
    double total = 0.0;
    for (var drug in drugPrescribed) {
      total += drug['total'];
    }

    return total;
  }
}
