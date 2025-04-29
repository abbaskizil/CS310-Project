import 'package:flutter/material.dart';
import 'package:athletech/utilities/styles.dart';
import 'package:athletech/utilities/colors.dart';

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
                dialogMessage: 'Welcome to the Account Privacy Screen!',
              ),
              _buildSettingItem(
                context: context,
                imagePath: 'assets/ContactUs_image.png',
                title: 'Contact Us',
                dialogMessage:
                    'You can reach out to us at support@example.com.',
              ),
              _buildSettingItem(
                context: context,
                imagePath: 'assets/UserAgreement_image.png',
                title: 'User Agreement',
                dialogMessage: 'Here is the User Agreement.',
              ),
              _buildSettingItem(
                context: context,
                imagePath: 'assets/AccountSettings_image.png',
                title: 'Account Settings',
                dialogMessage: 'Change your account settings here.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return Theme(
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String dialogMessage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: InkWell(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            bottomLeft: Radius.circular(40),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder:
                  (context) => _buildAlertDialog(
                    context,
                    title: title,
                    message: dialogMessage,
                  ),
            );
          },
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
                      Text('  $title', style: kButtonDarkTextStyle),
                      const Spacer(),
                      const Text(
                        '>',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(width: 16),
                    ],
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
