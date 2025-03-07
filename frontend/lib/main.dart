import 'package:flutter/material.dart';
import 'package:frontend_app/presentation/pages/beranda/beranda.dart';
import 'package:frontend_app/presentation/pages/autentikasi/login.dart';
import 'package:frontend_app/presentation/pages/monitoring/monitoirng_sensor/monitoring.dart';
import 'package:frontend_app/presentation/pages/manajemen/profile/profile.dart';
import 'package:frontend_app/presentation/pages/autentikasi/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}


