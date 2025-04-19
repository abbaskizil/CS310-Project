import 'package:athletech/screens/calorie_tracker.dart';
import 'package:flutter/material.dart';
import 'screens/SplashScreen.dart';

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
