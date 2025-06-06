import 'package:athletech/utilities/padding.dart';
import 'package:athletech/utilities/styles.dart';
import 'package:athletech/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  String gender = '';
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();

    if (data != null) {
      setState(() {
        ageController.text = data['age']?.toString() ?? '';
        heightController.text = data['height']?.toString() ?? '';
        weightController.text = data['weight']?.toString() ?? '';
        gender = data['gender'] ?? '';
      });
    }
  }

  void calculateBMI() {
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;

    if (height > 0 && weight > 0) {
      double bmi = weight / ((height / 100) * (height / 100));

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Your BMI', style: kButtonLightTextStyle),
          content: Text(bmi.toStringAsFixed(2)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appBarColor),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('BMI Calculator', style: kAppBarTitleTextStyle),
          centerTitle: true,
          backgroundColor: AppColors.appBarColor,
          elevation: 0,
        ),
        body: Padding(
          padding: AppPaddings.horizontal32Vertical40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/bmi.png', width: 100)),
              SizedBox(height: 20),
              Text('Age', style: kButtonLightTextStyle),
              SizedBox(height: 5),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.buttonColor,
                  hintText: 'Age',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Gender', style: kButtonLightTextStyle),
              Row(
                children: [
                  Radio(
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                  Text('Male', style: kButtonLightTextStyle),
                  Radio(
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                  Text('Female', style: kButtonLightTextStyle),
                ],
              ),
              SizedBox(height: 10),
              Text('Height', style: kButtonLightTextStyle),
              SizedBox(height: 5),
              TextField(
                controller: heightController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.buttonColor,
                  hintText: 'Height in cm',
                  suffixText: 'cm',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Weight', style: kButtonLightTextStyle),
              SizedBox(height: 5),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.buttonColor,
                  hintText: 'Weight in kg',
                  suffixText: 'kg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: calculateBMI,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                  ),
                  child: Padding(
                    padding: AppPaddings.symmetricH16,
                    child: Text('Calculate BMI', style: kButtonLightTextStyle)
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}