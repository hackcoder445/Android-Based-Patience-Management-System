import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:pms/screens/add_patient.dart';
import 'package:pms/screens/dashboard.dart';
import 'package:pms/screens/login.dart';
import 'package:pms/screens/medicine.dart';
import 'package:pms/screens/navbar.dart';
import 'package:pms/screens/patient_details.dart';
import 'package:pms/screens/patient_history.dart';
import 'package:pms/screens/patients.dart';
import 'package:pms/screens/payment_success.dart';
import 'package:pms/screens/prescribed_drugs.dart';
import 'package:pms/screens/prescription.dart';
import 'package:pms/screens/reports.dart';
import 'package:pms/screens/scanner/qr_scanner.dart';
import 'package:pms/screens/scanner/result.dart';
import 'package:pms/screens/splash.dart';
import 'package:pms/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PMS',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/dashboard', page: () => Dashboard()),
        GetPage(name: '/navbar', page: () => Navbar()),
        GetPage(name: '/patients', page: () => const Patients()),
        GetPage(name: '/add_patient', page: () => AddPatient()),
        GetPage(name: '/patient_details', page: () => PatientDetail()),
        GetPage(name: '/patient_history', page: () => const PatientHistory()),
        GetPage(name: '/medicine', page: () => Medicine()),
        GetPage(name: '/prescription', page: () => Prescription()),
        GetPage(name: '/payment_success', page: () => PaymentSuccessful()),
        GetPage(name: '/scan', page: () => Scan()),
        GetPage(name: '/result', page: () => ScannedQR()),
        GetPage(name: '/report', page: () => Report()),
        GetPage(name: '/prescribed_drugs', page: () => PrescribedDrugs()),
      ],
    );
  }
}
