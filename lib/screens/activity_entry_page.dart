import 'package:athletech/utilities/padding.dart';
import 'package:athletech/utilities/styles.dart';
import 'package:athletech/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'day_page.dart';
import 'package:intl/intl.dart';
import 'package:athletech/services/activity_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ActivityEntryApp extends StatelessWidget {
  const ActivityEntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appBarColor),
        useMaterial3: true,
      ),
      home: ActivityEntryPage(),
    );
  }
}

class ActivityEntryPage extends StatefulWidget {
  const ActivityEntryPage({super.key});

  @override
  _ActivityEntryPageState createState() => _ActivityEntryPageState();
}

class _ActivityEntryPageState extends State<ActivityEntryPage> {
  int duration = 0;
  int intensity = 1;
  String status = 'Completed'; // Keep 'Completed' as the initial default
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 8, minute: 0);
  String? selectedWorkout;
  TextEditingController notesController = TextEditingController();
  TextEditingController calorieController = TextEditingController();

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() => selectedTime = picked);
    }
  }

  @override
  void dispose() {
    // Remember to dispose of your controllers!
    notesController.dispose();
    calorieController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat.yMMMMd().format(selectedDate); // Added day for clarity
    final timeString = selectedTime.format(context);
    final workoutStyles = [
      {'label': 'Cycling', 'image': 'assets/cycling-image.jpeg'},
      {'label': 'Strength', 'image': 'assets/strength-image.jpeg'},
      {
        'label': 'Core&Abs',
        'image':
            'https://hips.hearstapps.com/menshealth-uk/main/thumbs/26789/abs.jpg?resize=980:*',
      },
      {'label': 'Pilates', 'image': 'assets/pilates-image.jpeg'},
       ];

    // Determine if the calorie/intensity fields should be visible
    final bool showCompletionDetails = status == 'Completed';


    return Scaffold(
      appBar: AppBar(
        title: Text("Activity Entry", style: kAppBarTitleTextStyle),
        centerTitle: true,
        backgroundColor: AppColors.appBarColor,
      ),
      body: Padding(
        padding: AppPaddings.all16,
        child: ListView(
          children: [
            Text("Select Workout Style", style: kButtonLightTextStyle),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: NeverScrollableScrollPhysics(),
              children:
                  workoutStyles.map((style) {
                    final label = style['label']!;
                    final image = style['image'];
                    final isSelected = selectedWorkout == label;
                    return GestureDetector(
                      onTap: () => setState(() => selectedWorkout = label),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            image != null
                                ? (image.startsWith('http')
                                    ? Image.network(image, fit: BoxFit.cover)
                                    : Image.asset(image, fit: BoxFit.cover))
                                : Container(color: Colors.grey.shade300),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                              ),
                            ),
                            Center(
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.send,
                                    width: 6,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text("Date", style: kButtonLightTextStyle),
              trailing: Text(dateString),
              onTap: _pickDate,
            ),
            ListTile(
              title: Text("Time", style: kButtonLightTextStyle),
              trailing: Text(timeString),
              onTap: _pickTime,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text("Duration: ", style: kButtonLightTextStyle),
                // Minus 5 Button
                ElevatedButton(
                  onPressed: () => setState(() {
                    duration = duration > 5 ? duration - 5 : 0; // Ensure duration doesn't go below 0
                  }),
                  child: const Text('-5'),
                ),
                const SizedBox(width: 8), // Added spacing
                // Minus 1 Button
                ElevatedButton(
                  onPressed: () => setState(() {
                    duration = duration > 0 ? duration - 1 : 0; // Ensure duration doesn't go below 0
                  }),
                  child: const Text('-1'),
                ),
                 const SizedBox(width: 16), // Added spacing
                Expanded( // Use Expanded to prevent overflow for the duration text
                   child: Text("$duration minutes", style: kButtonLightTextStyle),
                ),
                 const SizedBox(width: 16), // Added spacing
                // Plus 1 Button
                ElevatedButton(
                  onPressed: () => setState(() => duration = duration + 1),
                  child: const Text('+1'),
                ),
                 const SizedBox(width: 8), // Added spacing
                // Plus 5 Button
                ElevatedButton(
                  onPressed: () => setState(() => duration = duration + 5),
                  child: const Text('+5'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Start of conditional rendering for Completion Details ---
            if (showCompletionDetails) ...[ // Use the spread operator (...) to insert multiple widgets
              Text("Intensity Level", style: kButtonLightTextStyle),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  int level = index + 1;
                  return ChoiceChip(
                    label: Text("$level"),
                    selected: intensity == level,
                    selectedColor: AppColors.buttonColor,
                    onSelected: (_) => setState(() => intensity = level),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: calorieController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Burned Calorie',
                  border: OutlineInputBorder(),
                ),
                style: kButtonLightTextStyle,
              ),
              const SizedBox(height: 16),
            ],
            // --- End of conditional rendering ---

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Removed FilterChip for "Scheduled" for a cleaner look,
                // using Radio buttons instead if multiple statuses are needed.
                // Or keep FilterChips if preferred, just updating the state.
                 FilterChip(
                  label: Text("Scheduled"),
                  selected: status == 'Scheduled',
                  selectedColor: AppColors.buttonColor,
                  onSelected: (bool selected) {
                    setState(() {
                      status = selected ? 'Scheduled' : status; // Only update if selected
                    });
                  },
                ),
                FilterChip(
                  label: Text("In Progress"),
                  selected: status == 'In Progress',
                  selectedColor: AppColors.buttonColor,
                   onSelected: (bool selected) {
                    setState(() {
                      status = selected ? 'In Progress' : status; // Only update if selected
                    });
                  },
                ),
                FilterChip(
                  label: Text("Completed"),
                  selected: status == 'Completed',
                  selectedColor: AppColors.buttonColor,
                  onSelected: (bool selected) {
                    setState(() {
                      status = selected ? 'Completed' : status; // Only update if selected
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Add any details about your workout...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
              ),
              onPressed: () async {
                if (selectedWorkout == null || duration == 0) { // Calorie and Intensity are no longer mandatory if not Completed
                   Fluttertoast.showToast(
                    msg: 'Please select a workout style and set a duration.',
                  );
                  return;
                }

                // Additional check for calorie/intensity if status IS Completed
                 if (status == 'Completed' && (calorieController.text.isEmpty || int.tryParse(calorieController.text.trim()) == null)) {
                    Fluttertoast.showToast(
                     msg: 'Please enter a valid number for burned calories.',
                    );
                   return;
                 }


                try {
                  final activityService = ActivityService();
                  final now = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );

                  await activityService.addActivity(
                    type: selectedWorkout!,
                    duration: duration,
                    // Only include intensity and calories if status is Completed
                    intensity: status == 'Completed' ? intensity : 0, // Or handle as null in backend
                    caloriesBurned: status == 'Completed' ? (int.tryParse(calorieController.text.trim()) ?? 0) : 0, // Or handle as null
                    note: notesController.text.trim(),
                    scheduledDate: now,
                    status: status
                  );

                  Fluttertoast.showToast(msg: 'Activity created!');
                 Navigator.pushReplacement( // Example using pushReplacement
                   context,
                   MaterialPageRoute(builder: (context) => DayPage()),
                 );
                } catch (e) {
                  print('Error: $e');
                  Fluttertoast.showToast(msg: 'Failed to create activity.');
                }
              },
              child: Padding(
                padding: AppPaddings.all12,
                child: Text(
                  "Create the Activity",
                  style: kButtonLightTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
