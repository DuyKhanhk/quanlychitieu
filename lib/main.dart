import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanlychitieu/screens/home.dart';
import 'package:quanlychitieu/screens/phone_number.dart';
import 'package:quanlychitieu/screens/otp.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_10y.dart';

Future<void> main(List<String> args) async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'kdy quản lý chi tiêu',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? 'phone' : 'home',
      routes: {
        'phone': (context) => const PhoneNumber(),
        'otp': (context) => const OtpPhone(),
        'home': (context) => const Home(),
      },
      // home: const SpendingManagement(),
    );
  }
}
