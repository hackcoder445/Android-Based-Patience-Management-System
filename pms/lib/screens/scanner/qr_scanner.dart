import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultText.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  bool isScanCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const DefaultText(
            text: "Scan Invoice",
            // color: Constants.backgroundColor,
          ),
          centerTitle: true,
        ),
        backgroundColor: Constants.backgroundColor,
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  DefaultText(
                    text: "Place QR Code in the area",
                    size: 20.0,
                    weight: FontWeight.bold,
                    color: Constants.secondaryColor,
                  ),
                  DefaultText(
                    text: "Scanning will be automatically started",
                    size: 15.0,
                  ),
                ],
              )),
              Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      MobileScanner(
                          allowDuplicates: true,
                          onDetect: (barcode, args) {
                            if (!isScanCompleted) {
                              String code = barcode.rawValue ?? '------';
                              isScanCompleted = true;
                              Get.toNamed('/result', arguments: code);
                              
                            }
                          }),
                    ],
                  )),
              Expanded(child: Container()),
            ],
          ),
        ));
  }
}
