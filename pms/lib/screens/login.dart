import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pms/controllers/login_controller.dart';
import 'package:pms/services/remote_services.dart';
import 'package:pms/utils/constants.dart';
import 'package:pms/utils/defaultButton.dart';
import 'package:pms/utils/defaultText.dart';
import 'package:pms/utils/defaultTextFormField.dart';

class Login extends StatelessWidget {
  final controller = Get.put(BtnController());
  final _form = GlobalKey<FormState>();

  late String _username;
  late String _password;

  Login({super.key});

  _login() async {
    controller.isClicked.value = true;
    var isValid = _form.currentState!.validate();
    if (!isValid) return;

    _form.currentState!.save();
    await RemoteServices.login(_username, _password);
    controller.isClicked.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/images/pill_bottle.svg",
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 20),
                const DefaultText(
                  text: "Welcome Back",
                  color: Colors.black,
                  size: 30,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 30),
                Form(
                    key: _form,
                    child: Column(
                      children: [
                        DefaultTextFormField(
                          obscureText: false,
                          label: "Username",
                          icon: Icons.person,
                          fillColor: Colors.white,
                          validator: Constants.validator,
                          onSaved: (newValue) => _username = newValue!,
                          keyboardInputType: TextInputType.text,
                          // maxLines: 1,
                        ),
                        const SizedBox(height: 20),
                        Obx(() => DefaultTextFormField(
                              obscureText: controller.passwordHidden.value,
                              label: "Password",
                              icon: Icons.lock,
                              maxLines: 1,
                              fillColor: Colors.white,
                              validator: Constants.validator,
                              onSaved: (newValue) => _password = newValue!,
                              suffixIcon: GestureDetector(
                                onTap: () => controller.passwordHidden.value =
                                    !controller.passwordHidden.value,
                                child: Icon(controller.passwordHidden.value
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            )),
                        const SizedBox(height: 40),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Obx(() => DefaultButton(
                                  onPressed: () {
                                    _login();
                                    // controller.isClicked.value = true;
                                  },
                                  textSize: 18,
                                  child: controller.circ("Login"),
                                  // text: "Login",
                                )))
                      ],
                    )),
                const SizedBox(height: 30),
                Center(
                  child: InkWell(
                    onTap: () => Get.toNamed('/register'),
                    child: RichText(
                        text: const TextSpan(
                            text: "Having trouble logging in? ",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black87,
                                fontSize: 18),
                            children: [
                          TextSpan(
                            text: "Contact Admin",
                            style: TextStyle(
                                color: Constants.primaryColor,
                                fontWeight: FontWeight.bold),
                          )
                        ])),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
