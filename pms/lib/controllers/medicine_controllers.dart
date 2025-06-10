import 'package:get/get.dart';
import 'package:pms/models/medicine_response.dart';
import 'package:pms/services/remote_services.dart';

class MedicineController extends GetxController {
  RxList<MedicineResponse> medicines = <MedicineResponse>[].obs;

  @override
  onInit() async{
    super.onInit();
    await medicineList();
  }

  medicineList() async {
    List<MedicineResponse>? medicineList = await RemoteServices.medicineList();
    if (medicineList!.isNotEmpty) {
      medicines.value = medicineList;
    }
  }
}
