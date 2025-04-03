import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Example user data - you would fetch this from your backend or a service
  String _name = 'John';
  String _surname = 'Doe';
  String _email = 'john.doe@example.com';
  double _height = 180.0;
  double _weight = 75.0;
  int _age = 28;

  // Example user stats
  int _workoutCount = 2;
  int _calorieIntake = 376;
  int _distanceRan = 153; // example distance or steps

  void _editProfile() {
    // For now, let's just navigate to a new page or show a dialog
    // Or you can simply toggle an "edit mode" to allow inline editing
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile picture or placeholder
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),

            // User info
            ListTile(
              title: const Text('Name'),
              subtitle: Text(_name),
            ),
            ListTile(
              title: const Text('Surname'),
              subtitle: Text(_surname),
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(_email),
            ),
            ListTile(
              title: const Text('Height (cm)'),
              subtitle: Text(_height.toString()),
            ),
            ListTile(
              title: const Text('Weight (kg)'),
              subtitle: Text(_weight.toString()),
            ),
            ListTile(
              title: const Text('Age'),
              subtitle: Text(_age.toString()),
            ),
            const SizedBox(height: 16),

            // Stats
            Text(
              'Your Stats',
              style: Theme.of(context).textTheme.titleLarge,
            ),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// TODO:: BURAYA EDIT PROFILE PAGESINI YAPISTIR ISMI AYNI KALSIN 

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example minimal page
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: const Center(
        child: Text('Here you can edit your profile.'),
      ),
    );
  }
}
