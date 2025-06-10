import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pms/models/visitation_report_response.dart';
import 'package:pms/services/remote_services.dart';
import 'package:pms/utils/constants.dart';

class ReportController extends GetxController {
  Rx<DateTime> pickedDate = DateTime.now().obs;
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  var isClicked = false.obs;
  RxList<VisitationReportResponse>? visits = <VisitationReportResponse>[].obs;

  final isButtonClicked = false.obs;
  final isLoading = false.obs;

  pickDate(context) async {
    var selectedDate = await showDatePicker(
      context: context,
      initialDate: pickedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                    primary: Constants.primaryColor,
                    onPrimary: Constants.altColor,
                    onSurface: Constants.secondaryColor)),
            child: child!);
      },
    );

    if (selectedDate != null) {
      pickedDate.value = selectedDate;
    }
  }

  pickFromDate(context) async {
    await pickDate(context);
    fromDate.value.text = DateFormat("yyyy-MM-dd").format(pickedDate.value);
  }

  pickToDate(context) async {
    await pickDate(context);
    toDate.value.text = DateFormat("yyyy-MM-dd").format(pickedDate.value);
  }

  cir() {
    return Constants.circ(isClicked, "Submit");
  }

  Future<void> generateVisitReportList(String? from, String? to) async {
    isLoading.value = true;
    visits!.value =
        (await RemoteServices.generateVisitReport(from: from, to: to))!;
    isLoading.value = false;
  }
}
