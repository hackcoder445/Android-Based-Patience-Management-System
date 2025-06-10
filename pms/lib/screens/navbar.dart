import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms/controllers/navbar_controller.dart';
import 'package:pms/screens/dashboard.dart';
import 'package:pms/screens/more.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultText.dart';

class Navbar extends StatelessWidget {
  final controller = Get.put(NavbarController());
  Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentPage.value,
            children: const [Dashboard(), More()],
          )),
      bottomNavigationBar: Obx(() => CircleNavBar(
            onTap: (index) {
              controller.currentPage.value = index;
            },
            activeIndex: controller.currentPage.value,
            activeIcons: const [
              Icon(Icons.home, size: 40, color: Constants.altColor),
              Icon(Icons.more_horiz, size: 40, color: Constants.altColor),
            ],
            inactiveIcons: const [
              DefaultText(
                text: "Home",
                color: Constants.altColor,
                weight: FontWeight.bold,
                size: 15,
              ),
              DefaultText(
                text: "More",
                color: Colors.black,
                size: 15,
              ),
            ],
            height: 70,
            circleWidth: 70,
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
            cornerRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
            ),
            color: Constants.primaryColor,
            shadowColor: Constants.altColor,
            circleShadowColor: Constants.altColor,
            elevation: 20,
          )),
    );
  }
}
