import 'package:flutter/material.dart';
import 'sign_in_page.dart';
import 'package:athletech/utilities/padding.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Simulate network request
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      // Navigate to Sign In page after registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInPage()),
      );
    } else {
      // Show alert if form invalid
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Form'),
          content: const Text('Please correct the errors before proceeding.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.black, letterSpacing: 2.0, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Welcome to AthleTech!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Your Fitness Journey Companion',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 30),

              // Full Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: AppPaddings.all16,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Please enter your full name' : null,
              ),
              const SizedBox(height: 20),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: AppPaddings.all16,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: AppPaddings.all16,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Confirm Password
              TextFormField(
                controller: _confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: AppPaddings.all16,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Register Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Register', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
