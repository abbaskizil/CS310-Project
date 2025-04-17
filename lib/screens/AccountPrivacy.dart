import 'package:flutter/material.dart';
import 'main.dart';

void main() {
  runApp(const MaterialApp(
    home: AccountPrivacyScreen(),
  ));
}

class AccountPrivacyScreen extends StatelessWidget {
  const AccountPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(

            'Account Privacy Screen',
        style:TextStyle(
          color: Colors.black
        )),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Welcome to the Account Privacy Screen!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
