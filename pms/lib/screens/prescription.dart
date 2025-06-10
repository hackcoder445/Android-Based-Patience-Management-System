import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pms/controllers/prescription_controller.dart';
import 'package:pms/models/medicine_response.dart';
import 'package:pms/models/patient_list_response.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultButton.dart';
import 'package:pms/utils/defaultDropDown.dart';
import 'package:pms/utils/defaultText.dart';
import 'package:pms/utils/defaultTextFormField.dart';

class Prescription extends StatelessWidget {
  Prescription({super.key});

  final controller = Get.put(PrescriptionController());

  final _form = GlobalKey<FormState>();

  late String _diagnosis, _visitDate, _qty, _dosage;
  late String? _medicine;

  removeDrug(int index, var removedItem, var drugId) {
    controller.drugList.removeAt(index);

    controller.drugPrescribed
        .removeWhere((element) => element['drug'] == drugId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: Padding(
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
                    text: "Prescribe Drug",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      DropdownSearch<PatientListResponse>(
                        mode: Mode.MENU,
                        items: controller.patients,
                        showSearchBox: true,
                        itemAsString: (PatientListResponse? patient) =>
                            patient!.name!,
                        dropdownSearchDecoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Patient",
                            border: UnderlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(color: Colors.white))),
                        onChanged: (PatientListResponse? value) {
                          controller.patient!.value = value!.patientId!;
                          // print(value.patientId);
                        },
                        validator: Constants.patientValidator,
                      ),
                      const SizedBox(height: 20.0),
                      DefaultTextFormField(
                        text: controller.diagnosis.value,
                        obscureText: false,
                        hintText: "Diagnosis",
                        label: "Diagnosis",
                        validator: Constants.validator,
                        fillColor: Colors.white,
                        onSaved: (newValue) => _diagnosis = newValue!,
                      ),
                      const SizedBox(height: 20.0),
                      DropdownSearch<MedicineResponse>(
                        mode: Mode.MENU,
                        items: controller.medicines,
                        itemAsString: (MedicineResponse? med) => med!.name!,
                        showSearchBox: true,
                        dropdownSearchDecoration: const InputDecoration(
                            labelText: "Medicine",
                            fillColor: Colors.white,
                            filled: true,
                            border: UnderlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(color: Colors.white))),
                        onChanged: (value) {
                          controller.medicine!.value = value!.name!;
                          controller.price!.value = value.price!;
                          controller.medicineId!.value = value.medicineId!;
                        },
                        validator: Constants.medicineValidator,
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: DefaultTextFormField(
                            text: controller.qty.value,
                            label: "Quantity",
                            obscureText: false,
                            icon: Icons.date_range_outlined,
                            fillColor: Colors.white,
                            maxLines: 1,
                            keyboardInputType: TextInputType.number,
                            onSaved: (value) => _qty = value!,
                          )),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: DefaultTextFormField(
                              text: controller.dosage.value,
                              label: "Dosage",
                              obscureText: false,
                              icon: Icons.date_range_outlined,
                              fillColor: Colors.white,
                              maxLines: 1,
                              keyboardInputType: TextInputType.number,
                              onSaved: (value) => _dosage = value!,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => DefaultText(
                                  text:
                                      "Total: ${controller.calculateTotal(controller.drugList)}",
                                  size: 18.0,
                                  color: Constants.secondaryColor,
                                )),
                            DefaultButton(
                                onPressed: () {
                                  var isValid = _form.currentState!.validate();
                                  if (!isValid) return;

                                  _form.currentState!.save();
                                  controller.populateTable();
                                },
                                textSize: 15.0,
                                child: const DefaultText(
                                  text: "Add Drug to List",
                                  size: 15,
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Obx(() => Expanded(
                            flex: 3,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                Table(
                                  border: TableBorder.all(),
                                  children: [
                                    const TableRow(
                                        decoration: BoxDecoration(
                                            color: Constants.secondaryColor),
                                        children: [
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: DefaultText(
                                              text: "Name",
                                              size: 18.0,
                                              color: Constants.altColor,
                                              align: TextAlign.center,
                                            ),
                                          ),
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: DefaultText(
                                              text: "QTY",
                                              size: 18.0,
                                              color: Constants.altColor,
                                              align: TextAlign.center,
                                            ),
                                          ),
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: DefaultText(
                                              align: TextAlign.center,
                                              text: "Price",
                                              size: 18.0,
                                              color: Constants.altColor,
                                            ),
                                          ),
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: DefaultText(
                                              text: "Total",
                                              size: 18.0,
                                              color: Constants.altColor,
                                              align: TextAlign.center,
                                            ),
                                          ),
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: DefaultText(
                                              text: "Action",
                                              size: 18.0,
                                              color: Constants.altColor,
                                              align: TextAlign.center,
                                            ),
                                          ),
                                        ]),
                                    for (var index = 0;
                                        index < controller.drugList.length;
                                        index++)
                                      TableRow(
                                        children: [
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .top,
                                              child: DefaultText(
                                                  align: TextAlign.center,
                                                  text: controller
                                                      .drugList[index].name)),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: DefaultText(
                                                  align: TextAlign.center,
                                                  text: controller
                                                      .drugList[index].qty)),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: DefaultText(
                                                  align: TextAlign.center,
                                                  text: controller
                                                      .drugList[index].price
                                                      .toString())),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: DefaultText(
                                                  align: TextAlign.center,
                                                  text: controller
                                                      .drugList[index].total
                                                      .toString())),
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              child: IconButton(
                                                  onPressed: () {
                                                    removeDrug(
                                                        index,
                                                        controller
                                                            .drugList[index],
                                                        controller
                                                            .drugList[index]
                                                            .drugId);
                                                    // print(controller.drugList);
                                                    // print(
                                                    //     controller.drugPrescribed);
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ))),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      const Spacer(),
                      SizedBox(
                        width: size.width,
                        child: Obx(() => DefaultButton(
                              onPressed: () {
                                var isValid = _form.currentState!.validate();
                                if (!isValid) return;

                                _form.currentState!.save();
                                controller.isClicked.value = true;
                                controller.makePayment(context);
                              },
                              textSize: 18,
                              child: controller.cir(),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
