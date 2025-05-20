import 'package:athletech/services/calories_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:athletech/utilities/colors.dart';
import 'package:athletech/utilities/padding.dart';
import 'package:athletech/utilities/styles.dart';
import 'package:athletech/screens/settings.dart';
import 'package:athletech/services/user_service.dart';
import 'package:athletech/services/workout_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _profileFuture;
  late Future<Map<String, dynamic>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = UserService().getUserProfile();
    _statsFuture = WorkoutService().getUserStats();
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    ).then((_) {
      setState(() {
        _profileFuture = UserService().getUserProfile();
      });
    });
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
          title: Text('Profile', style: kAppBarTitleTextStyle),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<List<dynamic>>(
          future: Future.wait([_profileFuture, _statsFuture]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || snapshot.data == null) {
              print('Profile or stats load error: ${snapshot.error}');
              return const Center(child: Text("Failed to load profile/stats."));
            }

            final profileData = snapshot.data![0].data() as Map<String, dynamic>;
            final stats = snapshot.data![1] as Map<String, dynamic>;

            // Extract profile fields...
            final name = profileData['name'] ?? 'N/A';
            final surname = profileData['surname'] ?? 'N/A';
            final email = profileData['email'] ?? 'N/A';
            final gender = profileData['gender'] ?? 'N/A';
            final height = profileData['height']?.toString() ?? 'N/A';
            final weight = profileData['weight']?.toString() ?? 'N/A';
            final age = profileData['age']?.toString() ?? 'N/A';

            // Extract stats
            final workoutCount =
                (stats['workouts'] is int
                        ? stats['workouts']
                        : (stats['workouts'] as double?)?.toInt())
                    ?.toString() ??
                'N/A';

            final calorieBurnt =
                (stats['caloriesBurnt'] as num?)?.toStringAsFixed(2) ?? 'N/A';
            final calorieTaken =
                (stats['caloriesTaken'] as num?)?.toStringAsFixed(2) ?? 'N/A';
            final duration = stats['duration']?.toString() ?? 'N/A';

            return SingleChildScrollView(
              padding: AppPaddings.all16,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const NetworkImage(
                      'https://external-preview.redd.it/ehmAOFmGtL5VGRAq8Dkye2B9QlzVz0BzvT6o75NMgsc.jpg?auto=webp&s=ca3914b1948c660d10299f8dbc95a815dbf39043',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text('Name', style: kButtonLightTextStyle),
                          subtitle: Text(name),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text('Surname', style: kButtonLightTextStyle),
                          subtitle: Text(surname),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            'Weight (kg)',
                            style: kButtonLightTextStyle,
                          ),
                          subtitle: Text(weight),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text('Height', style: kButtonLightTextStyle),
                          subtitle: Text(height),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text('Age', style: kButtonLightTextStyle),
                          subtitle: Text(age),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text('Gender', style: kButtonLightTextStyle),
                          subtitle: Text(gender),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text('Email', style: kButtonLightTextStyle),
                    subtitle: Text(email),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildStatCards({
                        'Workouts': workoutCount,
                        'Duration (min)': duration,
                        'Calories Burnt': calorieBurnt,
                        'Calories Taken': calorieTaken,
                      }),
                    ),
                  ),

                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _editProfile,
                    icon: const Icon(Icons.edit),
                    label: Text('Edit Profile', style: kButtonLightTextStyle),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCards(Map<String, String> stats) {
    return GridView.builder(
      shrinkWrap: true, // Ensures the grid fits within the screen
      physics: const NeverScrollableScrollPhysics(), // Disables grid scrolling
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 cards per row
        crossAxisSpacing: 16.0, // Space between cards horizontally
        mainAxisSpacing: 16.0, // Space between cards vertically
        childAspectRatio: 1, // Maintains a square aspect ratio for the cards
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        // Get the keys and values for each stat card
        String title = stats.keys.elementAt(index);
        String value = stats.values.elementAt(index);

        return _buildStatCard(title, value);
      },
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: kButtonLightTextStyle.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: kButtonLightTextStyle.copyWith(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'Male';

  bool _isLoading = false;
  String _memberSince = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final snapshot = await _userService.getUserProfile();
      final data = snapshot.data();
      if (data != null) {
        setState(() {
          _nameController.text = data['name'] ?? '';
          _surnameController.text = data['surname'] ?? '';
          _heightController.text = data['height']?.toString() ?? '';
          _weightController.text = data['weight']?.toString() ?? '';
          _ageController.text = data['age']?.toString() ?? '';
          _gender = data['gender'] ?? 'Male';

          final timestamp = data['memberSince'];
          if (timestamp is Timestamp) {
            _memberSince =
                '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}';
          }
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _userService.saveUserProfile(
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        height: int.parse(_heightController.text.trim()),
        weight: int.parse(_weightController.text.trim()),
        age: int.parse(_ageController.text.trim()),
        gender: _gender,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error saving profile: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update profile')));
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
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
          title: Text('Edit Profile', style: kButtonLightTextStyle),
        ),
        body:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: AppPaddings.all16,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter name'
                                      : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _surnameController,
                          decoration: const InputDecoration(
                            labelText: 'Surname',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter surname'
                                      : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailControllerFromAuth(),
                          enabled: false,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Height (cm)',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter height'
                                      : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg)',
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter weight'
                                      : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Age'),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter age'
                                      : null,
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: _gender,
                          decoration: const InputDecoration(labelText: 'Gender'),
                          items: <String>[
                            'Male',
                            'Female',
                            'Other',
                            'Unspecified',  // ← add this
                          ].map((g) {
                            return DropdownMenuItem(
                              value: g,
                              child: Text(g),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) setState(() => _gender = value);
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            'Save Changes',
                            style: kButtonLightTextStyle,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _memberSince.isNotEmpty
                              ? 'Member since $_memberSince'
                              : '',
                          style: kButtonLightTextStyle,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Discard Changes'),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  TextEditingController _emailControllerFromAuth() {
    return TextEditingController(
      text: FirebaseAuth.instance.currentUser?.email ?? '',
    );
  }
}
