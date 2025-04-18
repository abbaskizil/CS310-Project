import 'package:flutter/material.dart';
import 'dart:async';
import 'settings.dart';
import 'sign_in_page.dart';

void main() {
  runApp(const AthleTechApp());
}

class AthleTechApp extends StatelessWidget {
  const AthleTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AthleTech',
      theme: ThemeData.dark(),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B20),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '/Users/ahmedberkaayhun/StudioProjects/AthleTech/assets/img_4.png',
              width: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'AthleTech',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your Fitness Journey Companion',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ModeButton(text: 'RUN'),
                SizedBox(width: 10),
                ModeButton(text: 'LIFT'),
                SizedBox(width: 10),
                ModeButton(text: 'TRACK'),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ModeButton extends StatelessWidget {
  final String text;
  const ModeButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

