import 'package:athletech/utilities/padding.dart';
import 'package:athletech/utilities/styles.dart';
import 'package:athletech/utilities/colors.dart';
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
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appBarColor),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.appBarColor,
          title: Text('Calorie Tracker', style: kAppBarTitleTextStyle),
          centerTitle: true,
        ),
        body: Padding(
          padding: AppPaddings.all16,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                onPressed: _addEntry,
                child: Text('Add Entry', style: kButtonLightTextStyle),
              ),
              const SizedBox(height: 16),

              // List of calorie entries
              Expanded(
                child:
                    _entries.isEmpty
                        ? Center(
                          child: Text(
                            'No entries yet.',
                            style: kButtonLightTextStyle,
                          ),
                        )
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
      ),
    );
  }
}
