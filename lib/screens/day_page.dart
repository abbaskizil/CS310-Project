import 'package:athletech/screens/calendar_page.dart';
import 'package:athletech/utilities/padding.dart';
import 'package:flutter/material.dart';
import 'package:athletech/utilities/styles.dart';
import 'package:athletech/utilities/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DayPage extends StatefulWidget {
  const DayPage({super.key});

  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  DateTime selectedDate = DateTime.now();

  Map<String, List<Map<String, dynamic>>> activities = {};
  Set<String> workoutDays = {}; 

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Fetch workouts from Firestore
    final snapshot =
        await FirebaseFirestore.instance
            .collection('workouts')
            .where('createdBy', isEqualTo: uid)
            .get();

    final Map<String, List<Map<String, dynamic>>> temp = {};
    final Set<String> daysWithWorkouts = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final timestamp = data['createdAt'] as Timestamp;
      final date = timestamp.toDate();

      // Use just the day of the month as the key for the workoutDays set
      final dayKey = date.day.toString();
      daysWithWorkouts.add(dayKey);

      // Use the full date (year-month-day) as the key for activities map
      // This is a more robust key for activities if you ever look beyond just the day number
      final activityDateKey = '${date.year}-${date.month}-${date.day}';

      temp.putIfAbsent(activityDateKey, () => []).add({
        'color': Colors.blueAccent,
        'title': data['type'] ?? 'Workout',
        'subtitle': 'Duration: ${data['duration']} min\nNotes: ${data['note']}',
      });
    }

    setState(() {
      activities = temp;
      workoutDays = daysWithWorkouts;
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- Start: Dynamically generate the dayList ---
    final now = DateTime.now();
    final dayList = <Map<String, String>>[];
    final weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']; // 0-indexed for convenience

    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      final dayNumber = date.day.toString();
      final weekdayLabel = weekdayLabels[date.weekday - 1]; // Adjust for 0-indexing

      dayList.add({
        'day': dayNumber,
        'label': weekdayLabel,
      });
    }
    // --- End: Dynamically generate the dayList ---

    // Create a key for accessing activities based on the selected full date
    final selectedDateKey = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
    final activitiesForSelectedDay = activities[selectedDateKey] ?? [];


    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appBarColor),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('AthleTech', style: kAppBarTitleTextStyle),
          centerTitle: true,
          backgroundColor: AppColors.appBarColor,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: AppPaddings.all16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CalendarPage()),
                      );
                    },
                    child: Text(
                      // Display the current month and year of the selected date
                      '${_getMonthName(selectedDate.month)} ${selectedDate.year} ▼',
                      style: kButtonLightTextStyle
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      dayList.map((d) {
                        // Check if the dynamically generated day matches the day of the selectedDate
                        final bool isSelected = selectedDate.day.toString() == d['day']!;
                        return GestureDetector(
                          // Update selectedDate to the full DateTime object
                          onTap: () {
                             // Find the actual DateTime corresponding to the tapped day
                             final tappedDay = dayList.indexOf(d); // 0 to 6
                             setState(() {
                               selectedDate = now.add(Duration(days: tappedDay));
                             });
                          },
                          child: _dayColumn(
                            d['day']!,
                            d['label']!,
                            isSelected, // Use the isSelected flag
                            hasWorkout: workoutDays.contains(d['day']!),
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Weekly View', style: kButtonLightTextStyle),
              const SizedBox(height: 10),
              // Removed the extra SizedBox here
              // const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.check_box_outline_blank),
                  const SizedBox(width: 10),
                  Text(
                    // Display the day and month of the selected date
                    '${selectedDate.day} ${_getMonthName(selectedDate.month)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(
                padding: AppPaddings.onlyLeft12,
                child: Text(
                  // Use the activitiesForSelectedDay list
                  '${activitiesForSelectedDay.length} activities scheduled',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
              // Use the activitiesForSelectedDay list for display
              Expanded( // Wrap the list of activities in Expanded and use ListView
                 child: ListView.builder(
                   itemCount: activitiesForSelectedDay.length,
                   itemBuilder: (context, index) {
                     final activity = activitiesForSelectedDay[index];
                     return Column(
                        children: [
                           _activityItem(
                             color: activity['color'], // Make sure color is stored if needed
                             title: activity['title'],
                             subtitle: activity['subtitle'],
                           ),
                           const SizedBox(height: 10),
                        ],
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

  // Helper function to get month name
  String _getMonthName(int month) {
    const monthNames = [
      '', // Month is 1-indexed
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month];
  }


  Widget _activityItem({
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          ),
        ),
        const CircleAvatar(
          radius: 14,
          backgroundColor: Colors.white,
          child: Icon(Icons.add_circle_outline, size: 20, color: Colors.grey),
        ),
      ],
    );
  }

  static Widget _dayColumn(
    String day,
    String label,
    bool selected, {
    bool hasWorkout = false,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Text(
              day,
              style: TextStyle(
                color: selected ? Colors.black : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasWorkout)
              Positioned(
                right: -8,
                top: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? Colors.black : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(color: selected ? Colors.black : Colors.grey),
          ),
        ),
      ],
    );
  }
}
