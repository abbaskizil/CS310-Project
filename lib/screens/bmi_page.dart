import 'package:athletech/utilities/padding.dart';
import 'package:athletech/utilities/styles.dart';
import 'package:flutter/material.dart';



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

  void calculateBMI() {
    double height = double.tryParse(heightController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0;

    if (height > 0 && weight > 0) {
      double bmi = weight / ((height / 100) * (height / 100));

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Your BMI', style: kButtonLightTextStyle,),
          content: Text(bmi.toStringAsFixed(2)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('BMI Calculator', style: kAppBarTitleTextStyle,),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 8, 6, 6),
        elevation: 0,
      ),
      body: Padding(
        padding: AppPaddings.all12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/bmi.png',
                width: 100,
              ),
            ),
            SizedBox(height: 20),
            Text('Age', style: kButtonLightTextStyle,),
            SizedBox(height: 5),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Gender', style: kButtonLightTextStyle,),
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
                Text('Male', style: kButtonLightTextStyle,),
                Radio(
                  value: 'Female',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                ),
                Text('Female', style: kButtonLightTextStyle,),
              ],
            ),
            SizedBox(height: 10),
            Text('Height', style: kButtonLightTextStyle,),
            SizedBox(height: 5),
            TextField(
              controller: heightController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Height in cm',
                suffixText: 'cm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Weight', style: kButtonLightTextStyle,),
            SizedBox(height: 5),
            TextField(
              controller: weightController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Weight in kg',
                suffixText: 'kg',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateBMI,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              child: Text('Calculate BMI', style: kButtonLightTextStyle,),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  padding: AppPaddings.all12,
                ),
                child: Text(
                  'Go to ChatBox',
                  style: kButtonLightTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
