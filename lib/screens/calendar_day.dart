import 'package:flutter/material.dart';
import 'activity_entry_page.dart';

class Pagecalendar extends StatefulWidget {
  const Pagecalendar({super.key});

  @override
  State<Pagecalendar> createState() => _PagecalendarState();
}

class _PagecalendarState extends State<Pagecalendar> {
  String selectedDay = '21'; // Default selected

  // Günlük adım ve kalori bilgileri
  final Map<String, Map<String, String>> statsPerDay = {
    '18': {'steps': '6,542', 'calories': '310'},
    '19': {'steps': '7,110', 'calories': '345'},
    '20': {'steps': '5,980', 'calories': '290'},
    '21': {'steps': '7,843', 'calories': '376'},
    '22': {'steps': '8,102', 'calories': '400'},
    '23': {'steps': '6,870', 'calories': '320'},
    '24': {'steps': '9,200', 'calories': '450'},
  };

  // Günlük aktiviteler
  Map<String, List<Map<String, dynamic>>> activities = {
    '21': [
      {'color': Colors.orange, 'title': 'Strength Training', 'subtitle': 'Gym - Total Duration: 01:15:00'},
      {'color': Colors.blue, 'title': 'Cardio Run', 'subtitle': 'Outdoor - Total Duration: 00:45:00'},
    ],
    '22': [
      {'color': Colors.green, 'title': 'Yoga', 'subtitle': 'Home - Duration: 00:30:00'},
    ],
  };

  void addActivity(String day) {
    setState(() {
      activities.putIfAbsent(day, () => []);
      activities[day]!.add({
        'color': Colors.purple,
        'title': 'New Activity',
        'subtitle': 'Manual entry - Duration: 00:20:00',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final dayList = [
      {'day': '18', 'label': 'Mon'},
      {'day': '19', 'label': 'Tue'},
      {'day': '20', 'label': 'Wed'},
      {'day': '21', 'label': 'Thu'},
      {'day': '22', 'label': 'Fri'},
      {'day': '23', 'label': 'Sat'},
      {'day': '24', 'label': 'Sun'},
    ];

    final currentStats = statsPerDay[selectedDay] ?? {'steps': '0', 'calories': '0'};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('AthleTech', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('March 2025 ▼', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),

          // Günler
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: dayList.map((d) {
                return GestureDetector(
                  onTap: () => setState(() => selectedDay = d['day']!),
                  child: _dayColumn(d['day']!, d['label']!, selectedDay == d['day']),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),
          const Text('Weekly View', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          Row(
            children: [
              _summaryBox('Daily Steps', currentStats['steps']!),
              const SizedBox(width: 10),
              _summaryBox('Calories', currentStats['calories']!),
            ],
          ),

          const SizedBox(height: 20),

          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ActivityEntryApp()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              child: const Text(
                'CREATE ACTIVITY',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              const Icon(Icons.check_box_outline_blank),
              const SizedBox(width: 10),
              Text('$selectedDay March', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 34.0),
            child: Text(
              '${activities[selectedDay]?.length ?? 0} activities scheduled',
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 20),

          // Aktiviteler
          ...?activities[selectedDay]?.map((activity) {
            return Column(
              children: [
                _activityItem(
                  color: activity['color'],
                  title: activity['title'],
                  subtitle: activity['subtitle'],
                ),
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
        ]),
      ),
    );
  }

  Widget _summaryBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black, // canlı yazı
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black, // canlı değer
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _activityItem({required Color color, required String title, required String subtitle}) {
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
                  color: Colors.black, // canlı hale geldi
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15, // biraz daha büyük
                ),
              ),
            ],
          ),
        ),
        const CircleAvatar(
          radius: 14,
          backgroundColor: Colors.white,
          child: Icon(Icons.add_circle_outline, size: 20, color: Colors.grey),
        )
      ],
    );
  }


  static Widget _dayColumn(String day, String label, bool selected) {
    return Column(
      children: [
        Text(day, style: TextStyle(color: selected ? Colors.black : Colors.grey, fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            border: Border.all(color: selected ? Colors.black : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label, style: TextStyle(color: selected ? Colors.black : Colors.grey)),
        ),
      ],
    );
  }
}
