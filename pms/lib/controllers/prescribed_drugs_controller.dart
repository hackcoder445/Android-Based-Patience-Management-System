import 'package:get/get.dart';
import 'package:pms/models/drug_prescription_response.dart';
import 'package:pms/services/remote_services.dart';

class PrescribedDrugControllers extends GetxController {
  var data = Get.arguments;

  List<DrugPrescriptionResponse> prescribedDrug =
      <DrugPrescriptionResponse>[].obs;

  @override
  void onInit() async {
    super.onInit();
    prescribedDrug = (await RemoteServices.getPrescribedDrugInvoice(data))!;
  }
}
