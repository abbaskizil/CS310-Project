import 'package:flutter/material.dart';
import 'AccountPrivacy.dart';
import 'AccountSettings.dart';
import 'ContactUs.dart';
import 'UserAgreement.dart';
void main() {
  runApp(MaterialApp(
    home:SettingsScreen(),
  ));
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: TextButton(
            onPressed: () {
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              '<',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),

        body:
        Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Image.asset(
                      '/Users/ahmedberkaayhun/StudioProjects/AthleTech/assets/img.png',
                      width: 40,
                      height: 40,
                    ),

                    Expanded(
                      child: Container(
                        height: 50,
                        margin:  EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 16),

                            Text(
                              '  Account Privacy',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                            Spacer(),

                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPrivacyScreen()),);                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child:  Text(
                                '>',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Image.asset(
                      '/Users/ahmedberkaayhun/StudioProjects/AthleTech/assets/img_1.png',
                      width: 40,
                      height: 40,
                    ),

                    Expanded(
                      child: Container(
                        height: 50,
                        margin:  EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:  BorderRadius.only(
                            topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),

                            const Text(
                              '  Contact Us',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                            const Spacer(),

                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsScreen()),);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child:  Text(
                                '>',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              SizedBox(height: 20,),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Image.asset(
                      '/Users/ahmedberkaayhun/StudioProjects/AthleTech/assets/img_2.png',
                      width: 40,
                      height: 40,
                    ),

                    Expanded(
                      child: Container(
                        height: 50,
                        margin:  EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:  BorderRadius.only(
                            topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 16),

                            Text(
                              '  User Agreement',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                            Spacer(),

                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => UserAgreementScreen()),);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                '>',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Image.asset(
                      '/Users/ahmedberkaayhun/StudioProjects/AthleTech/assets/img_3.png',
                      width: 40,
                      height: 40,
                    ),

                    Expanded(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),

                            const Text(
                              '  Account Settings',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                            const Spacer(),

                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettingsScreen()),);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                '>',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        )
    );
  }
}
