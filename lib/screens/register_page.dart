import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'sign_in_page.dart';
import 'package:athletech/utilities/padding.dart';
import 'package:athletech/utilities/styles.dart';
import 'package:athletech/utilities/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:athletech/services/user_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // split name into first + surname
  final _firstNameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _userService = UserService();
  bool _isLoading = false;

  final List<Map<String, dynamic>> defaultAchievements = [
    {
      'title': 'First Workout',
      'description': 'Complete your first workout session.',
      'icon': 'fitness_center',
      'completed': false,
      'progress': 0,
      'goal': 1,
    },
    {
      'title': 'Workout for 10 Hours',
      'description': 'Reach 10 hours of total workout time.',
      'icon': 'calendar_today',
      'completed': false,
      'progress': 0,
      'goal': 600, // in minutes
    },
    {
      'title': 'Burn 10,000 Calories',
      'description': 'Burn a total of 10,000 calories through workouts.',
      'icon': 'fitness_center',
      'completed': false,
      'progress': 0,
      'goal': 10000,
    },
    {
      'title': 'Morning Warrior',
      'description': 'Work out in the morning 10 times.',
      'icon': 'wb_sunny_outlined',
      'completed': false,
      'progress': 0,
      'goal': 10,
    },
  ];

  final Map<String, dynamic> welcomeAchievement = {
    'title': 'Welcome to AthleteTech!',
    'description': 'Thanks for joining – let’s get moving!',
    'icon': 'star',
    'completed': true,
    'dateEarned': Timestamp.now(),
  };

  Future<void> ensureInitialAchievements() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final achievementsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('achievements');

    final snapshot = await achievementsRef.limit(1).get();

    if (snapshot.docs.isEmpty) {
      final batch = FirebaseFirestore.instance.batch();

      // Add welcome achievement first (already completed)
      final welcomeDocRef = achievementsRef.doc();
      batch.set(welcomeDocRef, welcomeAchievement);

      // Add all default achievements (incomplete, progress = 0, dateEarned = null)
      for (final achievement in defaultAchievements) {
        final docRef = achievementsRef.doc();
        final data = Map<String, dynamic>.from(achievement);
        data['dateEarned'] = null;
        batch.set(docRef, data);
      }

      await batch.commit();
    }
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) {
      // show invalid‐form alert
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Invalid Form'),
              content: const Text(
                'Please correct the errors before proceeding.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // 1) Create Auth user
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2) Update displayName
      final fullName =
          '${_firstNameController.text.trim()} '
          '${_surnameController.text.trim()}';
      await cred.user!.updateDisplayName(fullName);

      // 3) Write initial Firestore doc with defaults
      await _userService.createUserProfile(
        name: _firstNameController.text.trim(),
        surname: _surnameController.text.trim(),
      );
      @override
      void initState() {
        super.initState();
        ensureInitialAchievements().then((_) => setState(() {}));
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInPage()),
      );
      MaterialPageRoute(builder: (_) => const SignInPage());
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered.';
          break;
        case 'weak-password':
          message = 'The password is too weak.';
          break;
        case 'invalid-email':
          message = 'Invalid email format.';
          break;
        default:
          message = 'Registration failed: ${e.message}';
      }
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Registration Failed'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
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
          backgroundColor: AppColors.appBarColor,
          title: Text('Create an Account', style: kAppBarTitleTextStyle),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: AppPaddings.horizontal20Vertical12,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text('Welcome to AthleTech!', style: kButtonDarkTextStyle),
                const SizedBox(height: 8),
                Text(
                  'Your Fitness Journey Companion',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 30),

                // First Name
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    hintText: 'Enter your first name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator:
                      (v) =>
                          v == null || v.isEmpty
                              ? 'Please enter your first name'
                              : null,
                ),
                const SizedBox(height: 16),

                // Surname
                TextFormField(
                  controller: _surnameController,
                  decoration: const InputDecoration(
                    labelText: 'Surname',
                    hintText: 'Enter your surname',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator:
                      (v) =>
                          v == null || v.isEmpty
                              ? 'Please enter your surname'
                              : null,
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Please enter your email';
                    final re = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    return re.hasMatch(v) ? null : 'Enter a valid email';
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Please enter a password';
                    return v.length < 6
                        ? 'Password must be at least 6 characters'
                        : null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password
                TextFormField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Please confirm your password';
                    return v != _passwordController.text
                        ? 'Passwords do not match'
                        : null;
                  },
                ),
                const SizedBox(height: 20),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text('Register', style: kButtonLightTextStyle),
                  ),
                ),

                const SizedBox(height: 16),

                // Redirect to Sign In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignInPage(),
                            ),
                          ),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
