import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultText.dart';

class BtnController extends GetxController {
  var passwordHidden = true.obs;

  var isClicked = false.obs;

  Widget circ(String action) {
    if (isClicked.value) {
      print(isClicked);
      return const CircularProgressIndicator(color: Constants.altColor);
    } else {
      print(isClicked);

      return DefaultText(text: action, color: Colors.white, size: 18.0);
    }
  }
}
