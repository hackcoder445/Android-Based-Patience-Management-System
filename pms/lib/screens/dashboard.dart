import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pms/main.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultGesture.dart';
import 'package:pms/utils/defaultText.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        title: const DefaultText(
          text: "Dashboard",
        ),
        actions: [
          IconButton(
              onPressed: () {
                sharedPreferences.clear();
                Get.offAllNamed('/login');
              },
              icon: const Icon(Icons.logout))
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DefaultGesture(
                  svgAsset: "assets/images/illness.svg",
                  tag: "Patients",
                  func: () {
                    Get.toNamed('/patients');
                  },
                ),
                DefaultGesture(
                  svgAsset: "assets/images/pills_1.svg",
                  tag: "Prescription",
                  func: () {
                    Get.toNamed('/prescription');
                  },
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DefaultGesture(
                  svgAsset: "assets/images/pill.svg",
                  tag: "Medicine",
                  func: () {
                    Get.toNamed('/medicine');
                  },
                ),
                DefaultGesture(
                  svgAsset: "assets/images/treatment_list.svg",
                  tag: "Reports",
                  func: () {
                    Get.toNamed('/report');
                  },
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
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
                    Get.toNamed('/scan');
                  },
                  child: const DefaultText(
                    color: Constants.primaryColor,
                    text: "Scan Receipt",
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
