import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:athletech/firebase_options.dart';

import 'screens/activity_entry_page.dart';
import 'screens/bmi_page.dart';
import 'screens/bottom_navigator.dart';
import 'screens/day_page.dart';
import 'screens/calendar_page.dart';
import 'package:athletech/screens/calorie_tracker.dart';
import 'screens/chat_screen.dart';
import 'package:athletech/screens/home_page.dart';
import 'screens/achievements_page.dart';
import 'screens/profile_page.dart';
import 'screens/register_page.dart';
import 'screens/settings.dart';
import 'screens/sign_in_page.dart';
import 'screens/SplashScreen.dart';
import 'utilities/colors.dart';
import 'package:athletech/screens/social_feed_page.dart';
import 'package:athletech/screens/workout_summary_page.dart';

import 'package:flutter/foundation.dart'; // Add this for kIsWeb

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: kIsWeb
        ? DefaultFirebaseOptions.web
        : DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/SplashScreen',
      routes: {
        '/activity_entry': (context) => ActivityEntryPage(),
        '/bmi': (context) => BmiPage(),
        '/bottom_navigator': (context) => BottomNavigator(),
        '/day': (context) => DayPage(),
        '/calendar': (context) => CalendarPage(),
        '/CalorieTracker': (context) => CalorieTracker(),
        '/chat': (context) => ChatScreen(),
        '/home_page': (context) => HomePage(),
        '/achievements': (context) => const AchievementsPage(),
        '/profile': (context) => ProfilePage(),
        '/register': (context) => RegisterPage(),
        '/settings': (context) => SettingsScreen(),
        '/sign_in': (context) => SignInPage(),
        '/SplashScreen': (context) => SplashScreen(),
        '/social_feed': (context) => const SocialFeedPage(),
        '/workout_summary': (context) => const WorkoutSummaryPage(),

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
