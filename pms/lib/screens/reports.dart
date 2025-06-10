import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pms/controllers/report_controllers.dart';
import 'package:pms/models/visitation_report_response.dart';
import 'package:pms/services/remote_services.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultButton.dart';
import 'package:pms/utils/defaultContainer.dart';
import 'package:pms/utils/defaultText.dart';
import 'package:pms/utils/defaultTextFormField.dart';

class Report extends StatelessWidget {
  Report({super.key});

  final controller = Get.put(ReportController());
  late String _from, _to;

  final _form = GlobalKey<FormState>();

  generateList() async {
    controller.isClicked.value = true;
    var isValid = _form.currentState!.validate();
    if (!isValid) return;

    _form.currentState!.save();

    var list = await RemoteServices.generateVisitReport(
        from: controller.fromDate.value.text, to: controller.toDate.value.text);

    if (list != null) {
      print(list);
    } else {}

    // print("gen: $visList");
    controller.isClicked.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                    text: "Generate Visitations",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              Form(
                  key: _form,
                  child: Column(
                    children: [
                      DefaultTextFormField(
                        label: "From",
                        text: controller.fromDate.value,
                        obscureText: false,
                        icon: Icons.date_range_outlined,
                        fillColor: Colors.white,
                        maxLines: 1,
                        onTap: () => controller.pickFromDate(context),
                        keyboardInputType: TextInputType.none,
                        onSaved: (value) => _from = value!,
                        validator: Constants.validator,
                      ),
                      const SizedBox(height: 20.0),
                      DefaultTextFormField(
                        label: "To",
                        text: controller.toDate.value,
                        obscureText: false,
                        icon: Icons.date_range_outlined,
                        fillColor: Colors.white,
                        maxLines: 1,
                        onTap: () => controller.pickToDate(context),
                        keyboardInputType: TextInputType.none,
                        onSaved: (value) => _to = value!,
                        validator: Constants.validator,
                      ),
                      const SizedBox(height: 40.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Obx(() => DefaultButton(
                            onPressed: () async {
                              // generateList();
                              controller.isButtonClicked.value = true;
                              controller.generateVisitReportList(
                                  controller.fromDate.value.text,
                                  controller.toDate.value.text);
                            },
                            textSize: 18,
                            child: controller.cir())),
                      )
                    ],
                  )),
              const SizedBox(height: 30.0),
              Obx(() {
                if (controller.isButtonClicked.value) {
                  return controller.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Constants.secondaryColor)
                      : FutureBuilder(
                          future: RemoteServices.generateVisitReport(
                              from: controller.fromDate.value.text,
                              to: controller.toDate.value.text),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.isEmpty) {
                              return const DefaultText(
                                text: "Can't get data",
                                size: 18.0,
                                color: Constants.secondaryColor,
                              );
                            } else if (snapshot.hasData) {
                              var data = snapshot.data;
                              return Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: data!.length,
                                    itemBuilder: (context, index) {
                                      return DefaultContainer(
                                        child: ListTile(
                                          title: DefaultText(
                                            text: data[index].patient!.name,
                                            size: 18,
                                          ),
                                          subtitle: DefaultText(
                                              text:
                                                  data[index].date.toString()),
                                          trailing: GestureDetector(
                                            onTap: () {
                                              Get.toNamed('/prescribed_drugs',
                                                  arguments:
                                                      data[index].presId);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              decoration: const BoxDecoration(
                                                color: Constants.primaryColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0)),
                                              ),
                                              child: const DefaultText(
                                                text: "view data",
                                                size: 12.0,
                                                color: Constants.altColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            }
                            return const SizedBox.shrink();
                          });
                } else {
                  return Container();
                }
              }),
              // ListView.builder(
              //     shrinkWrap: true,
              //     scrollDirection: Axis.vertical,
              //     physics: const AlwaysScrollableScrollPhysics(),
              //     itemCount: controller.visits!.length,
              //     itemBuilder: (context, index) {
              //       return DefaultContainer(
              //         child: ListTile(
              //           title: DefaultText(
              //             text: controller.visits![index].patient!.name,
              //             size: 18,
              //           ),
              //           subtitle: DefaultText(
              //               text: controller.visits![index].date.toString()),
              //           trailing: GestureDetector(
              //             child: const CircleAvatar(
              //               radius: 50,
              //               backgroundColor: Constants.primaryColor,
              //               child: DefaultText(
              //                 text: "view invoice",
              //                 size: 18.0,
              //                 color: Constants.altColor,
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     })
            ],
          ),
        ),
      ),
    );
  }
}
