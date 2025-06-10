import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pms/services/remote_services.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultButton.dart';
import 'package:pms/utils/defaultContainer.dart';
import 'package:pms/utils/defaultText.dart';

class ScannedQR extends StatelessWidget {
  ScannedQR({super.key});

  var code = Get.arguments;

  @override
  Widget build(BuildContext context) {
    print(code);
    return Scaffold(
        appBar: AppBar(
          title: const DefaultText(
            text: "Prescribed Drug Info",
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SafeArea(
            child: Center(
                child: Column(
              children: [
                FutureBuilder(
                    future: RemoteServices.getScannedDrugInvoice(code),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return const DefaultText(
                          text: "Can't get data",
                          size: 18.0,
                          color: Constants.secondaryColor,
                        );
                      } else if (snapshot.hasData) {
                        var data = snapshot.data!;
                        return Column(
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                    child: Image.memory(
                                  base64Decode(
                                      data[0].prescription!.patient!.imgMem!),
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )),
                                const SizedBox(width: 20.0),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    DefaultText(
                                      text:
                                          "${data[0].prescription!.patient!.name}",
                                      size: 20.0,
                                      color: Constants.secondaryColor,
                                    ),
                                    DefaultText(
                                      text:
                                          "${data[0].prescription!.patient!.address}",
                                      size: 20.0,
                                      color: Constants.secondaryColor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            DefaultText(
                              text:
                                  "Diagnosis: ${data[0].prescription!.diagnosis}",
                              size: 20.0,
                              color: Constants.secondaryColor,
                            ),
                            const SizedBox(height: 20.0),
                            DefaultText(
                              text:
                                  "Amount Paid: ${data[0].prescription!.total!}",
                              size: 18.0,
                              color: Constants.secondaryColor,
                            ),
                            const SizedBox(height: 20.0),
                            ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return DefaultContainer(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DefaultText(
                                            text:
                                                "Drug Name: ${data[index].drug!.name}",
                                            size: 18.0,
                                            color: Constants.secondaryColor,
                                          ),
                                          DefaultText(
                                            text:
                                                "Quantity: ${data[index].qty}",
                                            size: 18.0,
                                            color: Constants.secondaryColor,
                                          ),
                                          DefaultText(
                                            text: "Price: ${data[index].price}",
                                            size: 18.0,
                                            color: Constants.secondaryColor,
                                          ),
                                          DefaultText(
                                            text:
                                                "Dosage: ${data[index].dosage}",
                                            size: 18.0,
                                            color: Constants.secondaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                          ],
                        );
                      }
                      return const CircularProgressIndicator(
                          color: Constants.secondaryColor);
                    })
              ],
            )),
          ),
        ));
  }
}
