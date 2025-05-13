import 'package:athletech/utilities/styles.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:athletech/utilities/padding.dart';
import 'package:athletech/utilities/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0); // This seems unused in this page's build, but keeping it.
  TimeOfDay _endTime = const TimeOfDay(hour: 8, minute: 0); // This seems unused in this page's build, but keeping it.


  // This map stores activity data keyed by date string
  Map<String, List<Map<String, dynamic>>> activities = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print("User not logged in. Cannot fetch workouts for Calendar Page.");
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('workouts')
          .where('createdBy', isEqualTo: uid)
          // Optional: Add ordering if you want workouts sorted, e.g., by date
          // .orderBy('createdAt')
          .get();

      final Map<String, List<Map<String, dynamic>>> temp = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final timestamp = data['createdAt'] as Timestamp?; // Use nullable timestamp just in case
         if (timestamp == null) continue; // Skip documents without a timestamp

        final date = timestamp.toDate();
        // This key format is great for looking up activities by date
        final key = '${date.year}-${date.month}-${date.day}';

        // --- Retrieve the 'note' field here ---
        final note = data['note'] as String? ?? ''; // Get the note, default to empty string if null

        temp.putIfAbsent(key, () => []).add({
          'title': data['type'] ?? 'Workout',
          'duration': data['duration'] ?? 0,
          'calories': data['caloriesBurned'] ?? 0, // Corrected key name to match your ActivityEntryPage
          'status': data['status'] ?? 'N/A',
          'note': note, // <-- Add the note to the map!
           // Add other fields you might need here later
        });
      }

      setState(() {
        activities = temp;
      });
       if (_selectedDay != null) { // Trigger state update for the initially selected day
           // This often happens automatically with setState above, but good to be aware
       }


    } catch (e) {
      print('Error fetching workouts for CalendarPage: $e');
      // Optionally show an error message to the user
    }
  }

  // Helper function to create a formatted date string key
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  // This function is called by TableCalendar for each day
  // It returns a list of 'events' (workouts in our case) for the given day
  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final key = _formatDateKey(day);
    // Return the list associated with the key, or an empty list if no key exists
    return activities[key] ?? [];
  }


  @override
  Widget build(BuildContext context) {
    final key =
        _selectedDay != null
            ? _formatDateKey(_selectedDay!) // Use the helper function
            : '';
    final dayActivities = activities[key] ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar', style: kAppBarTitleTextStyle),
        backgroundColor: AppColors.appBarColor,
      ),
      body: Padding(
        padding: AppPaddings.all16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
              },
              eventLoader: _getEventsForDay, // <-- This is correct
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueGrey,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightBlueAccent,
                ),
                 // Optional: Customize event markers (dots)
                 markerDecoration: BoxDecoration(
                   color: Colors.black54, // Color of the dot
                   shape: BoxShape.circle,
                 ),
                 markersAutoAligned: true, // Auto-align the dots
                 markersOffset: PositionedOffset(bottom: 1), // Position dots slightly higher
                 markersMaxCount: 1, // Show at most 1 marker per day if multiple events
                 // You could use calendarBuilders for more complex markers or cell styling
              ),
            ),
            const SizedBox(height: 24),
            Text('Activities:', style: kButtonLightTextStyle),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: dayActivities.length,
                itemBuilder: (context, index) {
                  final activity = dayActivities[index];
                  // --- Access the note here ---
                  final String? note = activity['note']; // Retrieve the note

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Duration: ${activity['duration']} min'),
                            // Conditionally display Calories only if status is Completed and calories exist
                            if (activity['status'] == 'Completed' && (activity['calories'] is int || activity['calories'] is double) && activity['calories'] > 0)
                               Text('Calories: ${activity['calories']}'),
                          Text('Status: ${activity['status']}'),
                          // --- Conditionally display the note if it's not null or empty ---
                           if (note != null && note.isNotEmpty)
                             Text('Notes: $note'), // Display the note here
                        ],
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

  // _pickTime method remains the same (keeping it even if unused in build)
  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }
}

// _TimeField StatelessWidget remains the same (keeping it even if unused in build)
class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.time,
    required this.onTap,
    super.key,
  });

  final String label;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(time, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ),
      ],
    );
  }
}
