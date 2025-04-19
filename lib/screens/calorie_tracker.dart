import 'package:flutter/material.dart';

class CalorieEntry {
  final String name;
  final int calories;

  CalorieEntry({required this.name, required this.calories});
}

class CalorieTracker extends StatefulWidget {
  const CalorieTracker({super.key});

  @override
  State<CalorieTracker> createState() => _CalorieTrackerState();
}

class _CalorieTrackerState extends State<CalorieTracker> {
  final List<CalorieEntry> _entries = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _calorieController.dispose();
    super.dispose();
  }

  void _addEntry() {
    final name = _nameController.text.trim();
    final calorieText = _calorieController.text.trim();
    if (name.isEmpty || calorieText.isEmpty) return;
    final calories = int.tryParse(calorieText);
    if (calories == null) return;

    setState(() {
      _entries.add(CalorieEntry(name: name, calories: calories));
      _nameController.clear();
      _calorieController.clear();
    });
  }

  void _removeEntry(int index) {
    setState(() {
      _entries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Tracker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input fields for new entry
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Food Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _calorieController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Calories',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _addEntry,
              child: const Text('Add Entry'),
            ),
            const SizedBox(height: 16),

            // List of calorie entries
            Expanded(
              child: _entries.isEmpty
                  ? const Center(child: Text('No entries yet.'))
                  : ListView.builder(
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        final entry = _entries[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(entry.name),
                            subtitle: Text('${entry.calories} kcal'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeEntry(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}