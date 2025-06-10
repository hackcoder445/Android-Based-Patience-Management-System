import 'package:get/get.dart';
import 'package:pms/models/drug_prescription_response.dart';
import 'package:pms/services/remote_services.dart';

class PaymentController extends GetxController {
  var data = Get.arguments;
  RxList<DrugPrescriptionResponse> drugInvoice =
      <DrugPrescriptionResponse>[].obs;

  RxString prescription_id = ''.obs;

  drugInvoiceList() async {
    List<DrugPrescriptionResponse>? inv = await RemoteServices.getDrugInvoice();
    if (inv!.isNotEmpty) {
      drugInvoice.value = inv;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await RemoteServices.prescribeDrugs(
        drugsPrescribe: data['drug_prescribed'],
        patient: data['patientId'],
        diagnosis: data['diagnosis'],
        payment: true);

    await RemoteServices.getDrugInvoice();

    print("pres: $prescription_id");
  }
}
