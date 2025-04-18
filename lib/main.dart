import 'package:flutter/material.dart';
import 'screens/sign_in_page.dart';
import 'screens/profile_page.dart';
import 'screens/register_page.dart';
import 'screens/SplashScreen.dart';
import 'package:deneme1app/screens/bmi_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
    );
  }
}
