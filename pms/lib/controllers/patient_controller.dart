import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pms/models/patient_list_response.dart';
import 'package:pms/services/remote_services.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultText.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PatientController extends GetxController {
  var isClicked = false.obs;
  var isEnabled = false.obs;

  Rx<DateTime> pickedDate = DateTime.now().obs;
  RxString dropdownvalue = ''.obs;

  Rx<TextEditingController> name = TextEditingController().obs;
  Rx<TextEditingController> address = TextEditingController().obs;
  Rx<TextEditingController> dob = TextEditingController().obs;
  Rx<TextEditingController> phone = TextEditingController().obs;
  Rx<TextEditingController> gender = TextEditingController().obs;
  var img = File('').obs;

  var data = Get.arguments;

  @override
  void onInit() async {
    super.onInit();
    if (data != null) {
      await patientDetails();
    }
  }

  patientDetails() async {
    PatientListResponse? patientDetail =
        await RemoteServices.patientDetails(data['patient']);

    print(patientDetail.runtimeType);

    if (patientDetail != null) {
      name.value.text = patientDetail.name!;
      address.value.text = patientDetail.address!;
      dob.value.text = patientDetail.dob!.toString();
      phone.value.text = patientDetail.phone!;
      gender.value.text = patientDetail.gender!;
    } else {
      print("is Null");
    }
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
      dob.value.text = DateFormat("yyyy-MM-dd").format(pickedDate.value);
    }
  }

  cir() {
    return Constants.circ(isClicked, "Update");
  }

  cir1() {
    return Constants.circ(isClicked, "Submit");
  }

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imgPerm = await saveImagePermanently(image.path);
      img.value = imgPerm;
    } catch (e) {
      Get.showSnackbar(Constants.customSnackBar(
          message: "An error occurred: $e", tag: false));
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = Path.basename(imagePath);
    final image = File("${directory.path}/$name");

    print(image);
    return File(imagePath).copy(image.path);
  }
}
