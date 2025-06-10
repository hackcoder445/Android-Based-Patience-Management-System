// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pms/controllers/payment_controller.dart';
import 'package:pms/models/drug_prescription_response.dart';
import 'package:pms/models/invoice.dart';
import 'package:pms/models/patient_list_response.dart';
import 'package:pms/services/remote_services.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultButton.dart';
import 'package:pms/utils/defaultContainer.dart';
import 'package:pms/utils/defaultText.dart';
import 'package:checkmark/checkmark.dart';
import 'package:pms/utils/pdf_api.dart';
import 'package:pms/utils/pdf_invoice_api.dart';

class PaymentSuccessful extends StatelessWidget {
  PaymentSuccessful({super.key});

  final data = Get.arguments;

  final controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100.0),
            const SizedBox(
              child: Icon(
                Icons.check_circle,
                color: Constants.secondaryColor,
                size: 250,
              ),
            ),
            const SizedBox(height: 20.0),
            DefaultText(
              text: data['message'],
              size: 18.0,
              color: Constants.secondaryColor,
            ),
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  padding:
                      MaterialStateProperty.all(const EdgeInsets.all(15.0)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      side: BorderSide(color: Constants.primaryColor),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                onPressed: () async {
                  final date = DateTime.now();
                  final dueDate = date.add(Duration(days: 7));
                  List<DrugPrescriptionResponse>? ites =
                      await RemoteServices.getDrugInvoice();
                  // print("ites: ${ites}");

                  final invoice = Invoice(
                    info: InvoiceInfo(
                        date: date,
                        dueDate: dueDate,
                        description: "Drug Prescription",
                        number: data['invoice_number']),
                    customer: PatientListResponse(
                        name: "${ites![0].prescription!.patient!.name}",
                        address: "${ites[0].prescription!.patient!.address}"),
                    items: controller.drugInvoice.value,
                    diagnosis:
                        controller.drugInvoice[0].prescription!.diagnosis,
                  );

                  final pdfFile = await PdfInvoiceApi.generate(
                      invoice,
                      controller.prescription_id.value,
                      controller.drugInvoice[0].prescription!.patient!.name);
                  PdfApi.openFile(pdfFile);
                  // print("generated");
                  Constants.dialogBox(context,
                      text: "Invoice Generated",
                      color: Colors.white,
                      textColor: Constants.secondaryColor,
                      actions: [
                        TextButton(
                            onPressed: () {
                              Get.close(3);
                            },
                            child: const DefaultText(
                              text: "okay",
                            ))
                      ]);
                },
                child: const DefaultText(
                  color: Constants.primaryColor,
                  text: "Generate Receipt",
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Constants.altColor),
                  padding:
                      MaterialStateProperty.all(const EdgeInsets.all(15.0)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      side: const BorderSide(color: Constants.primaryColor),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Get.close(2);
                },
                child: const DefaultText(
                  color: Constants.primaryColor,
                  text: "Go to Home",
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
