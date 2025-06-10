import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pms/services/remote_services.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultContainer.dart';
import 'package:pms/utils/defaultText.dart';
import 'package:pms/utils/defaultTextFormField.dart';

class Patients extends StatelessWidget {
  const Patients({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    text: "Patients",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  )
                ],
              ),
              const SizedBox(height: 40.0),
              // const DefaultTextFormField(
              //   label: "Search by name",
              //   obscureText: false,
              //   icon: Icons.search_outlined,
              //   fillColor: Colors.white,
              //   maxLines: 1,
              // ),
              const DefaultText(
                text: "Below is the list of patient",
                size: 20,
                color: Constants.secondaryColor,
              ),
              const SizedBox(height: 50),
              FutureBuilder(
                future: RemoteServices.patientList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return DefaultText(text: "No Patient");
                  } else if (snapshot.hasData) {
                    var data = snapshot.data;
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return DefaultContainer(
                            child: GestureDetector(
                              onTap: () => Get.toNamed('/patient_details',
                                  arguments: {
                                    "patient": data[index].patientId
                                  }),
                              child: ListTile(
                                leading: ClipOval(
                                    child: Image.memory(
                                  base64Decode(data[index].imgMem.toString()),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )),
                                title: DefaultText(text: "${data[index].name}"),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const CircularProgressIndicator(
                      color: Constants.altColor);
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed('/add_patient');
          },
          child: const DefaultText(
            text: "+",
            size: 30,
            weight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
