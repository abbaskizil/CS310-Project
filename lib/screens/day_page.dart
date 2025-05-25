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
        'id'      : doc.id,
        'color'   : Colors.blueAccent,
        'title'   : data['type']    ?? 'Workout',
        'duration': data['duration']?? 0,
        'note'    : data['note']    as String? ?? '',
        'status'  : data['status']  as String? ?? 'Scheduled',
        'calories': (data['caloriesBurned'] as num?)?.toInt() ?? 0,  // ← new
        'subtitle': 'Duration: ${data['duration'] ?? 0} min\nNotes: ${data['note'] ?? ''}',
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
              Expanded(
                child: ListView.builder(
                  itemCount: activitiesForSelectedDay.length,
                  itemBuilder: (context, index) {
                    final activity = activitiesForSelectedDay[index];

                    // null‐safe reads
                    final title    = activity['title']    as String? ?? 'Workout';
                    final duration = activity['duration'] as int?    ?? 0;
                    final note     = activity['note']     as String? ?? '';
                    final status   = activity['status']   as String? ?? 'Incomplete';
                    final color    = activity['color']    as Color?  ?? Colors.grey;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          // • dot
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 10),

                          // • text block
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 17)),
                                Text('Duration: $duration min'),
                                if (note.isNotEmpty) Text('Notes: $note'),
                                Text('Status: $status'),
                                if (status == 'Completed')
                                  Text('Calories: ${activity['calories'] as int? ?? 0}'),
                              ],
                            ),
                          ),

                          // — Edit button
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueGrey),
                            tooltip: 'Edit entry',
                            onPressed: () => _showEditDialog(selectedDate, index),
                          ),

                          // — Status dropdown (marking)
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.flag_outlined),
                            tooltip: 'Change status',
                            onSelected: (newStatus) {
                            if (newStatus == 'Completed')
                                _showCaloriesDialog(selectedDate, index);
                            else
                                _updateStatus(selectedDate, index, newStatus);
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: 'Scheduled',  child: Text('Scheduled')),
                              PopupMenuItem(value: 'In Progress', child: Text('In Progress')),
                              PopupMenuItem(value: 'Completed',   child: Text('Completed')),
                            ],
                          ),

                          // — Delete button
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            tooltip: 'Delete entry',
                            onPressed: () => _deleteEntry(selectedDate, index),
                          ),
                        ],
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

  // Helper function to get month name
  String _getMonthName(int month) {
    const monthNames = [
      '', // Month is 1-indexed
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month];
  }

  Future<void> _updateStatus(
      DateTime day, int index, String newStatus) async {
    final key = '${day.year}-${day.month}-${day.day}';
    final workout = activities[key]![index];
    final docId = workout['id'] as String;

    // 1) Write it back to Firestore
    await FirebaseFirestore.instance
        .collection('workouts')
        .doc(docId)
        .update({'status': newStatus});

    // 2) And update local state so the UI refreshes instantly
    setState(() {
      activities[key]![index]['status'] = newStatus;
    });
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
  
  Future<void> _deleteEntry(DateTime day, int index) async {
    final key = '${day.year}-${day.month}-${day.day}';
    final workout = activities[key]![index];
    final docId = workout['id'] as String;

    // 1) Remove from Firestore
    await FirebaseFirestore.instance
        .collection('workouts')
        .doc(docId)
        .delete();

    // 2) Remove locally so UI updates
    setState(() {
      activities[key]!.removeAt(index);
      if (activities[key]!.isEmpty) {
        activities.remove(key);
        workoutDays.remove(day.day.toString());
      }
    });
  }

  void _showEditDialog(DateTime day, int index) {
    final key = '${day.year}-${day.month}-${day.day}';
    final workout = activities[key]![index];

    // start values
    String titleVal    = workout['title']    as String? ?? 'Strength';
    final durationCtl = TextEditingController(
        text: (workout['duration'] as int?)?.toString() ?? '0');
    final noteCtl     = TextEditingController(text: workout['note'] as String? ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Workout'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            // Style dropdown only
            DropdownButtonFormField<String>(
              value: titleVal,
              decoration: const InputDecoration(labelText: 'Workout Style'),
              items: const [
                DropdownMenuItem(value: 'Strength',  child: Text('Strength')),
                DropdownMenuItem(value: 'Cycling',   child: Text('Cycling')),
                DropdownMenuItem(value: 'Core&Abs',  child: Text('Core&Abs')),
                DropdownMenuItem(value: 'Pilates',   child: Text('Pilates')),
              ],
              onChanged: (v) { if (v!=null) titleVal=v; },
            ),

            const SizedBox(height: 12),

            // Duration field
            TextField(
              controller: durationCtl,
              decoration: const InputDecoration(labelText: 'Duration (min)'),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 12),

            // Notes field
            TextField(
              controller: noteCtl,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newDuration = int.tryParse(durationCtl.text.trim())
                                  ?? (workout['duration'] as int? ?? 0);
              final newNote     = noteCtl.text.trim();

              // update Firestore
              await FirebaseFirestore.instance
                  .collection('workouts')
                  .doc(workout['id'] as String)
                  .update({
                'type':     titleVal,
                'duration': newDuration,
                'note':     newNote,
              });

              // update local
              setState(() {
                workout['title']    = titleVal;
                workout['duration'] = newDuration;
                workout['note']     = newNote;
              });

              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCaloriesDialog(DateTime day, int index) async {
    final key = '${day.year}-${day.month}-${day.day}';
    final workout = activities[key]![index];
    final existing = workout['calories'] as int? ?? 0;
    final ctl = TextEditingController(text: existing.toString());

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Calories Burned'),
        content: TextField(
          controller: ctl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Calories'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final cal = int.tryParse(ctl.text.trim()) ?? existing;
              final docId = workout['id'] as String;
              // 1) Update Firestore
              await FirebaseFirestore.instance
                  .collection('workouts')
                  .doc(docId)
                  .update({
                'status': 'Completed',
                'caloriesBurned': cal,
              });
              // 2) Update local state
              setState(() {
                workout['status']   = 'Completed';
                workout['calories'] = cal;
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

}
