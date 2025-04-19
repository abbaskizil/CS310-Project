import 'package:athletech/screens/settings.dart';
import 'package:flutter/material.dart';

import 'package:athletech/utilities/padding.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Example user data - you would fetch this from your backend or a service
  final String _name = 'John';
  final String _surname = 'Doe';
  final String _email = 'john.doe@example.com';
  final String _gender = "Male";
  final double _height = 180.0;
  final double _weight = 75.0;
  final int _age = 28;

  // Example user stats
  final int _workoutCount = 2;
  final int _calorieIntake = 376;
  final int _distanceRan = 153; // example distance or steps

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: <Widget>[
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
      // bottomNavigationBar: null, // <-------------------
      body: SingleChildScrollView(
        padding: AppPaddings.all16,
        child: Column(
          children: [
            // Profile picture or placeholder
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage(
                'https://external-preview.redd.it/ehmAOFmGtL5VGRAq8Dkye2B9QlzVz0BzvT6o75NMgsc.jpg?auto=webp&s=ca3914b1948c660d10299f8dbc95a815dbf39043',
              ), // Using NetworkImage here
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Name'),
                    subtitle: Text(_name),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Surname'),
                    subtitle: Text(_surname),
                  ),
                ),
              ],
            ),

            // User info
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Weight (kg)'),
                    subtitle: Text(_weight.toString()),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Height'),
                    subtitle: Text(_height.toString()),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Age'),
                    subtitle: Text(_age.toString()),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Gender'),
                    subtitle: Text(_gender.toString()),
                  ),
                ),
              ],
            ),

            ListTile(title: const Text('Email'), subtitle: Text(_email)),

            const SizedBox(height: 16),

            // Stats
            Text('Your Stats', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Workouts', _workoutCount.toString()),
                _buildStatCard('Calories', _calorieIntake.toString()),
                _buildStatCard('Distance', _distanceRan.toString()),
              ],
            ),
            const SizedBox(height: 24),

            // Edit Profile Button
            ElevatedButton.icon(
              onPressed: _editProfile,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 2,
      child: Container(
        width: 100,
        padding: AppPaddings.all16,
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: AppPaddings.onlyLeft12,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: const [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black12,
                  child: Icon(Icons.person, size: 50, color: Colors.black),
                ),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.add, size: 16, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Member since 21/03/2025',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: AppPaddings.all16,
                child: Column(
                  children: const [
                    ProfileItem(label: 'Name', value: 'sampleName'),
                    ProfileItem(label: 'Surname', value: 'sampleSurname'),
                    ProfileItem(label: 'Email', value: 'youremail@gmail.com'),
                    ProfileItem(
                      label: 'Height',
                      value: '171',
                      trailing: 'Weight',
                      trailingValue: '62',
                    ),
                    ProfileItem(
                      label: 'Age',
                      value: '21',
                      trailing: 'Gender',
                      trailingValue: 'Male',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              child: const Text('Discard Changes'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String label;
  final String value;
  final String? trailing;
  final String? trailingValue;

  const ProfileItem({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
    this.trailingValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.edit, size: 18),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(value, style: const TextStyle(color: Colors.grey)),
                    if (trailing != null) ...[
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          trailing!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        trailingValue ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
