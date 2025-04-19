import 'package:flutter/material.dart';

class Pagecalendar extends StatelessWidget {
  const Pagecalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('AtheleTech', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'March 2025 ▼',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),


            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _dayColumn('18', 'Mon', false),
                  _dayColumn('19', 'Tue', false),
                  _dayColumn('20', 'Wed', false),
                  _dayColumn('21', 'Thu', true),
                  _dayColumn('22', 'Fri', false),
                  _dayColumn('23', 'Sat', false),
                  _dayColumn('24', 'Sun', false),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Weekly View', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Row(
              children: [
                _summaryBox('Daily Steps', '7,843'),
                const SizedBox(width: 10),
                _summaryBox('Calories', '376'),
              ],
            ),
            const SizedBox(height: 20),

            // CREATE ACTIVITY
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: const Text('CREATE ACTIVITY'),
              ),
            ),
            const SizedBox(height: 20),

            const Row(
              children: [
                Icon(Icons.check_box_outline_blank),
                SizedBox(width: 10),
                Text('21 March Thursday', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 34.0),
              child: Text('2 activities scheduled', style: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 20),

            // Aktiviteler
            _activityItem(color: Colors.orange, title: 'Strength Training', subtitle: 'Gym - Total Duration: 01:15:00'),
            const SizedBox(height: 10),
            _activityItem(color: Colors.blue, title: 'Cardio Run', subtitle: 'Outdoor - Total Duration: 00:45:00'),
          ],
        ),
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
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _activityItem({required Color color, required String title, required String subtitle}) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
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
