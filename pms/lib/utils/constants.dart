import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pms/models/medicine_response.dart';
import 'package:pms/models/patient_list_response.dart';
import 'package:pms/services/remote_services.dart';
import 'package:pms/utils/defaultButton.dart';
import 'package:pms/utils/defaultText.dart';
import 'package:pms/utils/defaultTextFormField.dart';

class Constants {
  // static const Color primaryColor = Colors.blue;
  static const Color primaryColor = Color(0xFF5A81FA);
  static const Color altColor = Color(0xFFCDDEFF);
  static const Color backgroundColor = Color(0xFFF2F5FF);
  static const Color secondaryColor = Color(0xFF2C3D8F);
  static const Color containerColor = Color.fromARGB(255, 189, 162, 122);

  static formatPrice(double price) => '=N= ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);

  static String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Field is required";
    }
    return null;
  }

  static String? medicineValidator(MedicineResponse? value) {
    if (value == null) {
      return "Field is required";
    }
    return null;
  }

  static String? patientValidator(PatientListResponse? value) {
    if (value == null) {
      return "Field is required";
    }
    return null;
  }

  static customSnackBar({String? title, String? message, required bool tag}) {
    return GetSnackBar(
        title: title,
        // message: message,
        messageText: DefaultText(
          text: message,
          color: Colors.white,
        ),
        backgroundColor: tag ? Colors.green : Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
        margin: EdgeInsets.all(20.0),
        borderRadius: 10);
  }

  static dialogBox(
    context, {
    String? text,
    Color? color,
    Color? textColor,
    IconData? icon,
    // String? buttonText,
    List<Widget>? actions,
    // void Function()? buttonAction,
  }) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: color,
              content: SizedBox(
                height: 180.0,
                child: Column(
                  children: [
                    Icon(
                      icon,
                      size: 70.0,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 20.0),
                    DefaultText(
                      size: 20.0,
                      text: text!,
                      color: textColor,
                      align: TextAlign.center,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              actions: actions,
            ));
  }

  static void showDrugDetails(Size size, String medicineId, String nameText,
      String priceText, BuildContext context) {
    final _form = GlobalKey<FormState>();
    late String _name, _price;

    TextEditingController name = TextEditingController(text: nameText);
    TextEditingController price = TextEditingController(text: priceText);

    updateDrug(String id) async {
      var isValid = _form.currentState!.validate();
      if (!isValid) return;
      _form.currentState!.save();

      await RemoteServices.medicineUpdate(id, name: _name, price: _price);

      print("Data collected: $_name, $_price");
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      DefaultTextFormField(
                        text: name,
                        obscureText: false,
                        hintText: "Name",
                        label: "Name",
                        validator: Constants.validator,
                        onSaved: (newValue) => _name = newValue!,
                      ),
                      const SizedBox(height: 20.0),
                      DefaultTextFormField(
                        text: price,
                        obscureText: false,
                        hintText: "Price",
                        label: "Price",
                        validator: Constants.validator,
                        keyboardInputType: TextInputType.number,
                        onSaved: (newValue) => _price = newValue!,
                      ),
                      // const Spacer(),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: size.width,
                        child: DefaultButton(
                            onPressed: () {
                              // controller.isClicked.value = true;
                              updateDrug(medicineId);
                            },
                            textSize: 18,
                            child: const DefaultText(
                              text: "Update Drug",
                              size: 18.0,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget circ(Rx<bool> isClicked, String action) {
    if (isClicked.value) {
      return const CircularProgressIndicator(
        color: Constants.altColor,
      );
    } else {
      return DefaultText(text: action, color: Colors.white, size: 18.0);
    }
  }

  // static getPath() async {
  //   // Directory? dir;
  //   // get the download folder
  //   try {
  //     if (await Permission.manageExternalStorage.isGranted) {
  //       final path = await getExternalStorageDirectory();
  //       // final path = Directory('/storage/emulated/0/pmsInvoice/');
  //       String directory = '';
  //       if (await path!.exists()) {
  //         directory = path.path;
  //         print("re: $directory");
  //       } else {
  //         final Directory dirNewFolder = await path.create(recursive: true);
  //         directory = dirNewFolder.path;
  //         print("re3: $directory");
  //       }
  //       // if (!await path.exists()) directory = await getExternalStorageDirectory();
  //       print("directory-$directory");
  //       return directory;
  //     } else {
  //       await Permission.manageExternalStorage.request();
  //     }
  //   } catch (err) {
  //     Get.showSnackbar(Constants.customSnackBar(
  //         message: "Can't get folder, $err", tag: false));
  //   }
  // }

  static Future<String> getPath() async {
    Directory? dir;
    // get the download folder
    try {
      if (await Permission.manageExternalStorage.isGranted) {
        Platform.isIOS
            ? dir = await getApplicationDocumentsDirectory()
            : dir = Directory('/storage/emulated/0/Download');
        // check external storage if download is not gotten
        if (!await dir.exists()) dir = await getExternalStorageDirectory();
      } else {
        await Permission.manageExternalStorage.request();
      }
    } catch (err) {
      Get.showSnackbar(Constants.customSnackBar(
          message:
              "Can't get download folder, check if storage permission is enabled",
          tag: false));
    }

    print("dir: ${dir!.path}");
    return dir!.path;
  }
}
