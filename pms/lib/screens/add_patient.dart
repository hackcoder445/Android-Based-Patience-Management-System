import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pms/controllers/patient_controller.dart';
import 'package:pms/services/remote_services.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultButton.dart';
import 'package:pms/utils/defaultDropDown.dart';
import 'package:pms/utils/defaultText.dart';
import 'package:pms/utils/defaultTextFormField.dart';

class AddPatient extends StatelessWidget {
  AddPatient({super.key});

  final controller = Get.put(PatientController());
  late String _name, _gender, _phone;
  late String _address, _dob;
  Map gender = {'male': 'male', 'female': 'female'};

  TextEditingController name = TextEditingController();
  TextEditingController regNo = TextEditingController();

  final _form = GlobalKey<FormState>();
  _submit() async {
    controller.isClicked.value = true;
    var isValid = _form.currentState!.validate();
    if (!isValid) {
      controller.isClicked.value = false;
      return;
    }

    _form.currentState!.save();
    await RemoteServices.addPatient(
        _name, _address, _phone, _gender, _dob, controller.img.value);
    controller.isClicked.value = false;
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Constants.secondaryColor),
                      iconSize: 25,
                    ),
                    const DefaultText(
                      text: "Add Patient",
                      size: 20.0,
                      color: Constants.secondaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const DefaultText(
                    text: "Fill below form to add a patient", size: 18.0),
                const SizedBox(height: 30),
                Obx(() => Stack(children: [
                      ClipOval(
                        child: controller.img.value.existsSync()
                            ? Image.file(
                                controller.img.value,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/default.jpg",
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            controller.getImage(ImageSource.gallery);
                            // Navigator.pop(context);
                          },
                          child: Column(
                            children: const [
                              Icon(
                                Icons.image_outlined,
                                size: 30.0,
                                color: Constants.secondaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ])),
                const SizedBox(height: 10.0),
                Form(
                    key: _form,
                    child: Column(
                      children: [
                        DefaultTextFormField(
                          obscureText: false,
                          fontSize: 20.0,
                          label: "Name",
                          fillColor: Colors.white,
                          onSaved: (value) {
                            _name = value!;
                          },
                          validator: Constants.validator,
                        ),
                        const SizedBox(height: 20.0),
                        DefaultTextFormField(
                          obscureText: false,
                          fontSize: 20.0,
                          label: "Address",
                          maxLines: 5,
                          fillColor: Colors.white,
                          onSaved: (value) {
                            _address = value!;
                          },
                          validator: Constants.validator,
                        ),
                        const SizedBox(height: 20.0),
                        DefaultTextFormField(
                          label: "Date of Birth",
                          text: controller.dob.value,
                          obscureText: false,
                          icon: Icons.date_range_outlined,
                          fillColor: Colors.white,
                          maxLines: 1,
                          onTap: () => controller.pickDate(context),
                          keyboardInputType: TextInputType.none,
                          onSaved: (value) => _dob = value!,
                        ),
                        const SizedBox(height: 20.0),
                        DefaultTextFormField(
                          obscureText: false,
                          fontSize: 20.0,
                          label: "Phone",
                          fillColor: Colors.white,
                          onSaved: (value) {
                            _phone = value!;
                          },
                          validator: Constants.validator,
                          keyboardInputType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20.0),
                        DefaultDropDown(
                          onChanged: (newVal) {
                            controller.dropdownvalue.value = newVal;
                          },
                          dropdownMenuItemList: gender
                              .map((key, value) => MapEntry(
                                  key,
                                  DropdownMenuItem(
                                    value: key,
                                    child: DefaultText(
                                      text: value.toString(),
                                    ),
                                  )))
                              .values
                              .toList(),
                          value: controller.dropdownvalue.value,
                          text: "Gender",
                          onSaved: (newVal) {
                            _gender = newVal;
                          },
                          validator: (value) {
                            if (value == null || value == '') {
                              return "field is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Obx(() => DefaultButton(
                              onPressed: () {
                                _submit();
                              },
                              textSize: 18,
                              child: controller.cir1())),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
