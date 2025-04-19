import 'package:athletech/utilities/padding.dart';
import 'package:athletech/utilities/styles.dart';
import 'package:athletech/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'calendar_day.dart';
import 'package:intl/intl.dart';


class ActivityEntryApp extends StatelessWidget {
  const ActivityEntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  String status = 'Completed';
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
  Widget build(BuildContext context) {
    final dateString = DateFormat.yMMMM().format(selectedDate);
    final timeString = selectedTime.format(context);
    final workoutStyles = [
      {
        'label': 'Cycling',
        'image': 'assets/cycling-image.jpeg' 
      },
      {
        'label': 'Strength',
        'image': 'assets/strength-image.jpeg' 
      },
      {
        'label': 'Core&Abs',
        'image': 'https://hips.hearstapps.com/menshealth-uk/main/thumbs/26789/abs.jpg?resize=980:*'
      },
      {
        'label': 'Pilates',
        'image': 'assets/pilates-image.jpeg'
      },
    ];


    return Scaffold(
      appBar: AppBar(
        title: Text("Activity Entry", style: kAppBarTitleTextStyle,),
        centerTitle: true,
      ),
      body: Padding(
        padding: AppPaddings.all16,
        child: ListView(
          children: [
            Text("Select Workout Style", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: NeverScrollableScrollPhysics(),
              children: workoutStyles.map((style) {
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
                              border: Border.all(color: Colors.deepPurple, width: 4),
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
              title: Text("Date"),
              trailing: Text(dateString),
              onTap: _pickDate,
            ),
            ListTile(
              title: Text("Time"),
              trailing: Text(timeString),
              onTap: _pickTime,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text("Duration: ", style: TextStyle(fontSize: 16)),
                IconButton(
                  onPressed: () => setState(() => duration = duration > 0 ? duration - 1 : 0),
                  icon: Icon(Icons.remove_circle_outline),
                ),
                Text("$duration minutes", style: TextStyle(fontWeight: FontWeight.w500)),
                IconButton(
                  onPressed: () => setState(() => duration++),
                  icon: Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("Intensity Level", style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                int level = index + 1;
                return ChoiceChip(
                  label: Text("$level"),
                  selected: intensity == level,
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
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilterChip(
                  label: Text("Scheduled"),
                  selected: status == 'Scheduled',
                  onSelected: (_) => setState(() => status = 'Scheduled'),
                ),
                FilterChip(
                  label: Text("In Progress"),
                  selected: status == 'In Progress',
                  onSelected: (_) => setState(() => status = 'In Progress'),
                ),
                FilterChip(
                  label: Text("Completed"),
                  selected: status == 'Completed',
                  onSelected: (_) => setState(() => status = 'Completed'),
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
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Pagecalendar()),
                  );
              },
              child: Padding(
                padding: AppPaddings.all12,
                child: Text("Create the Activity", style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
