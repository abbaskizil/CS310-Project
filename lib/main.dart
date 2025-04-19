import 'package:flutter/material.dart';
import 'screens/activity_entry_page.dart';
import 'screens/bmi_page.dart';
import 'screens/bottom_navigator.dart';
import 'screens/calendar_day.dart';
import 'screens/calendar_page.dart';
import 'package:athletech/screens/calorie_tracker.dart';
import 'screens/chat_screen.dart';
import 'package:athletech/screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/register_page.dart';
import 'screens/settings.dart';
import 'screens/sign_in_page.dart';
import 'screens/SplashScreen.dart';
import 'utilities/colors.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/SplashScreen',
      routes: {
        '/activity_entry': (context) => ActivityEntryApp(),
        '/bmi': (context) => BmiPage(),
        '/bottom_navigator': (context) => BottomNavigator(),
        '/day': (context) => Pagecalendar(),
        '/calendar': (context) => CalendarPage(),
        '/CalorieTracker': (context) => CalorieTracker(),
        '/chat': (context) => ChatScreen(),
        '/home_page': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/register': (context) => RegisterPage(),
        '/settings': (context) => SettingsScreen(),
        '/sign_in': (context) => SignInPage(),
        '/SplashScreen': (context) => SplashScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          elevation: 0.0,
          centerTitle: true,
        ),
      ),
    );
  }
}
