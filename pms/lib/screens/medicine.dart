import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms/services/remote_services.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultButton.dart';
import 'package:pms/utils/defaultContainer.dart';
import 'package:pms/utils/defaultText.dart';
import 'package:pms/utils/defaultTextFormField.dart';

class Medicine extends StatelessWidget {
  Medicine({super.key});

  final _form = GlobalKey<FormState>();
  late String _name, _price;

  _addDrug() async {
    var isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();

    await RemoteServices.addMedicine(name: _name, price: double.parse(_price));
    // print("Data collected: $_name, $_price");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                    text: "Medicine",
                    size: 20.0,
                    color: Constants.secondaryColor,
                  )
                ],
              ),
              const SizedBox(height: 40.0),
              const DefaultTextFormField(
                label: "Search by name",
                obscureText: false,
                icon: Icons.search_outlined,
                fillColor: Colors.white,
                maxLines: 1,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DefaultButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0))),
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Form(
                                        key: _form,
                                        child: Column(
                                          children: [
                                            DefaultTextFormField(
                                              obscureText: false,
                                              hintText: "Name",
                                              label: "Name",
                                              validator: Constants.validator,
                                              onSaved: (newValue) =>
                                                  _name = newValue!,
                                            ),
                                            const SizedBox(height: 20.0),
                                            DefaultTextFormField(
                                              obscureText: false,
                                              hintText: "Price",
                                              label: "Price",
                                              validator: Constants.validator,
                                              keyboardInputType:
                                                  TextInputType.number,
                                              onSaved: (newValue) =>
                                                  _price = newValue!,
                                            ),
                                            // const Spacer(),
                                            const SizedBox(height: 20.0),
                                            SizedBox(
                                              width: size.width,
                                              child: DefaultButton(
                                                  onPressed: () {
                                                    _addDrug();
                                                  },
                                                  textSize: 18,
                                                  child: const DefaultText(
                                                    text: "Submit",
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      textSize: 18,
                      child: const DefaultText(text: "Add Drug"))
                ],
              ),
              const SizedBox(height: 20.0),
              FutureBuilder(
                  future: RemoteServices.medicineList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return DefaultText(
                        text: "No Drug",
                      );
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
                                onTap: () {
                                  Constants.showDrugDetails(
                                      size,
                                      "${data[index].medicineId}",
                                      "${data[index].name}",
                                      "${data[index].price}",
                                      context);
                                },
                                child: ListTile(
                                  title: DefaultText(
                                      text: data[index].name,
                                      color: Constants.secondaryColor,
                                      size: 18.0),
                                  trailing: DefaultText(
                                      text: data[index].price.toString()),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return const CircularProgressIndicator(
                        color: Constants.secondaryColor);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
