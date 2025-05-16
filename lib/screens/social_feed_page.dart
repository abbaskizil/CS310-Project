import 'package:flutter/material.dart';
import 'package:athletech/services/social_feed_service.dart';
import 'package:athletech/utilities/padding.dart';
import 'package:athletech/utilities/styles.dart';
import 'package:athletech/utilities/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';   // createdAt için dönüşüm

class SocialFeedPage extends StatelessWidget {
  const SocialFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stream = SocialFeedService().getPosts();   // gerçek-zamanlı akış

    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appBarColor),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Social Feed', style: kAppBarTitleTextStyle),
          centerTitle: true,
          backgroundColor: AppColors.appBarColor,
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: stream,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('Hata: ${snap.error}'));
            }
            final posts = snap.data ?? [];
            if (posts.isEmpty) {
              return const Center(child: Text('Henüz paylaşım yok.'));
            }

            return ListView.builder(
              padding: AppPaddings.all12,
              itemCount: posts.length,
              itemBuilder: (context, i) {
                final p = posts[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.buttonColor,
                      child: Text(
                        (p['userName'] ?? '?').toString().substring(0, 1).toUpperCase(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    title: Text('${p['userName']} • ${p['type']}'),
                    subtitle: Text(
                      'Duration: ${p['duration']} dk'
                          '${(p['caloriesBurned'] ?? 0) > 0 ? ' • Calories burned: ${p['caloriesBurned']}' : ''}'
                          '${(p['note'] ?? '').toString().isNotEmpty ? '\nNote: ${p['note']}' : ''}',
                    ),
                    trailing: Text(
                      _fmtDate(p['createdAt']),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _fmtDate(dynamic ts) {
    if (ts == null) return '';
    final d = ts is DateTime ? ts : (ts as Timestamp).toDate();
    return '${d.day}.${d.month}.${d.year}';
  }
}
