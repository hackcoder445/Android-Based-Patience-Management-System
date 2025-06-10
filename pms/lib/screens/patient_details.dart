import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pms/controllers/patient_controller.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultButton.dart';
import 'package:pms/utils/defaultContainer.dart';
import 'package:pms/utils/defaultDropDown.dart';
import 'package:pms/utils/defaultText.dart';
import 'package:pms/utils/defaultTextFormField.dart';

class PatientDetail extends StatelessWidget {
  PatientDetail({super.key});

  final data = Get.arguments;
  final controller = Get.put(PatientController());
  Map gender = {'male': 'male', 'female': 'female'};

  @override
  Widget build(BuildContext context) {
    // print(data);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Constants.secondaryColor,
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const DefaultText(
                          text: "Patient Profile",
                          color: Colors.white,
                          size: 20.0),
                      IconButton(
                          onPressed: () {
                            controller.isEnabled.value =
                                !controller.isEnabled.value;
                          },
                          icon: const Icon(
                            Icons.edit_note_sharp,
                            size: 40,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  Stack(children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          border: Border.all(color: Colors.white, width: 5.0),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/default.jpg",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )),
                  ]),
                  const SizedBox(height: 10.0),
                  DefaultText(
                    text: controller.name.value.text,
                    weight: FontWeight.bold,
                    size: 20.0,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed('/patient_history'),
                        child: const DefaultContainer(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: DefaultText(
                              text: "History",
                              color: Constants.secondaryColor,
                              size: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                    child: Obx(
                  () => Column(
                    children: [
                      Obx(() => DefaultTextFormField(
                            text: controller.name.value,
                            obscureText: false,
                            fontSize: 20.0,
                            label: "Name",
                            fillColor: Colors.white,
                            enabled: controller.isEnabled.value,
                          )),
                      const SizedBox(height: 20.0),
                      Obx(() => DefaultTextFormField(
                            text: controller.address.value,
                            obscureText: false,
                            fontSize: 20.0,
                            label: "Address",
                            maxLines: 5,
                            fillColor: Colors.white,
                            enabled: controller.isEnabled.value,
                          )),
                      const SizedBox(height: 20.0),
                      Obx(() => DefaultTextFormField(
                            label: "Date of Birth",
                            text: controller.dob.value,
                            obscureText: false,
                            icon: Icons.date_range_outlined,
                            fillColor: Colors.white,
                            enabled: controller.isEnabled.value,
                            maxLines: 1,
                            onTap: () => controller.pickDate(context),
                            keyboardInputType: TextInputType.none,
                          )),
                      const SizedBox(height: 20.0),
                      Obx(() => DefaultTextFormField(
                            text: controller.phone.value,
                            obscureText: false,
                            fontSize: 20.0,
                            label: "Phone",
                            fillColor: Colors.white,
                            keyboardInputType: TextInputType.phone,
                            enabled: controller.isEnabled.value,
                          )),
                      const SizedBox(height: 20.0),
                      Obx(() => DefaultTextFormField(
                            text: controller.gender.value,
                            obscureText: false,
                            fontSize: 20.0,
                            label: "Gender",
                            fillColor: Colors.white,
                            keyboardInputType: TextInputType.phone,
                            enabled: controller.isEnabled.value,
                          )),
                      const SizedBox(height: 30.0),
                      controller.isEnabled.value
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Obx(() => DefaultButton(
                                    onPressed: () {},
                                    textSize: 18,
                                    child: controller.cir(),
                                  )))
                          : const SizedBox.shrink()
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
