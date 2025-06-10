import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pms/screens/login.dart';
import 'package:pms/utils/defaultText.dart';

import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Constants.primaryColor,
      splash: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/pharmacy.svg",
                width: 200, height: 200),
            // const DefaultText(
            //   text: "PMS",
            //   color: Constants.containerColor,
            //   size: 30,
            // )
          ],
        ),
      ),
      // backgroundColor: Constants.backgroundColor,
      splashIconSize: 300.0,
      nextScreen: Login(),
    );
  }
}
