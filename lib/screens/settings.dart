import 'package:flutter/material.dart';
import 'package:athletech/utilities/styles.dart';
import 'package:athletech/utilities/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appBarColor),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.appBarColor,
          title: Text('Settings', style: kAppBarTitleTextStyle),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSettingItem(
                context: context,
                imagePath: 'assets/AccountPrivacy_image.png',
                title: 'Account Privacy',
                onTap: () => _showDialog(context, 'Account Privacy', 'Welcome to the Account Privacy Screen!'),
              ),
              _buildSettingItem(
                context: context,
                imagePath: 'assets/ContactUs_image.png',
                title: 'Contact Us',
                onTap: () => _showDialog(context, 'Contact Us', 'You can reach out to us at support@example.com.'),
              ),
              _buildSettingItem(
                context: context,
                imagePath: 'assets/UserAgreement_image.png',
                title: 'User Agreement',
                onTap: () => _showDialog(context, 'User Agreement', 'Here is the User Agreement.'),
              ),
              _buildSettingItem(
                context: context,
                imagePath: 'assets/AccountSettings_image.png',
                title: 'Account Settings',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                ),
              ),
              _buildSettingItem(
                context: context,
                imagePath: 'assets/logout_icon.png',
                title: 'Log out',
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) Navigator.of(context)
                      .pushNamedAndRemoveUntil('/sign_in', (r) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required String imagePath,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: InkWell(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
        onTap: onTap,
        child: Row(
          children: [
            Image.asset(imagePath, width: 40, height: 40),
            Expanded(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: AppColors.buttonColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Text(title, style: kButtonDarkTextStyle),
                    const Spacer(),
                    const Text('>', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (c) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appBarColor),
          useMaterial3: true,
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title, style: kAppBarTitleTextStyle),
          content: Text(message, style: kButtonDarkTextStyle),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(c).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ChangePasswordScreen içinde hem şifre güncelleme hem de hesap silme ayrı inputlarla
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPwController = TextEditingController();
  final _newPwController = TextEditingController();
  final _deletePwController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _currentPwController.dispose();
    _newPwController.dispose();
    _deletePwController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() { _error = null; _isLoading = true; });
    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!, password: _currentPwController.text.trim(),
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(_newPwController.text.trim());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password successfully updated.')),
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/sign_in', (r) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() { _error = e.message; });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() { _error = null; _isLoading = true; });
    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!, password: _deletePwController.text.trim(),
      );
      await user.reauthenticateWithCredential(cred);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
      await user.delete();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your account has been deleted.')),
        );
        Navigator.of(context).pushNamedAndRemoveUntil('/sign_in', (r) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() { _error = e.message; });
    } finally {
      setState(() => _isLoading = false);
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
          title: Text('Account Settings', style: kAppBarTitleTextStyle),
          backgroundColor: AppColors.appBarColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _currentPwController,
                      decoration: const InputDecoration(labelText: 'Current Password'),
                      obscureText: true,
                      validator: (v) => v == null || v.isEmpty ? 'Current password required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _newPwController,
                      decoration: const InputDecoration(labelText: 'New Password'),
                      obscureText: true,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'New password required';
                        if (v.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : () {
                        if (_formKey.currentState!.validate()) _changePassword();
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Update Password'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 40),
              // Separate delete password field
              TextField(
                controller: _deletePwController,
                decoration: const InputDecoration(labelText: 'Current Password for Deletion'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: _isLoading ? null : _deleteAccount,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Delete My Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
