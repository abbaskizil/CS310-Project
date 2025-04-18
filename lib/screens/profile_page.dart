import 'package:flutter/material.dart';

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
  final double _height = 180.0;
  final double _weight = 75.0;
  final int _age = 28;

  // Example user stats
  final int _workoutCount = 2;
  final int _calorieIntake = 376;
  final int _distanceRan = 153; // example distance or steps

  void _editProfile() {
    // TODO:: HERE WE NEED TO CHANGE THE ROUTE TO THE EDITPAGE WHEN ADDED
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      // bottomNavigationBar: null, // <-------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                    title: const Text('Age'),
                    subtitle: Text(_age.toString()),
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
        padding: const EdgeInsets.all(16),
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

// TODO:: BURAYA EDIT PROFILE PAGESINI YAPISTIR ISMI AYNI KALSIN  <------------------------ AYDIN
// YA DA YENI DOSYA ACACAKSAN BURAYI SIL.  
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example minimal page
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Here you can edit your profile.')),
    );
  }
}
///////////////////////////////////////////////////////////////////////



