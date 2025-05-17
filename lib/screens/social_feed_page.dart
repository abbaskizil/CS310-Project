import 'package:flutter/material.dart';
import 'package:athletech/services/social_feed_service.dart';
import 'package:athletech/utilities/padding.dart';
import 'package:athletech/utilities/styles.dart';
import 'package:athletech/utilities/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SocialFeedPage extends StatelessWidget {
  const SocialFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stream = SocialFeedService().getPosts();

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
              return Center(child: Text('Error: ${snap.error}'));
            }
            final posts = snap.data ?? [];
            if (posts.isEmpty) {
              return const Center(child: Text('There is not any post yet.'));
            }

            return ListView.builder(
              padding: AppPaddings.all12,
              itemCount: posts.length,
              itemBuilder: (context, i) {
                final p = posts[i];
                final postId = p['id'] as String;       // ensure your getPosts() includes `id`
                final userName = p['userName'] ?? '?';
                final type     = p['type']     ?? '';
                final duration = p['duration'] ?? '';
                final calories = p['caloriesBurned'] ?? 0;
                final note     = (p['note'] ?? '').toString();
                final createdAt= p['createdAt'];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.buttonColor,
                      child: Text(
                        userName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    title: Text('$userName • $type'),
                    subtitle: Text(
                      'Duration: $duration dk'
                      '${calories > 0 ? ' • Calories burned: $calories' : ''}'
                      '${note.isNotEmpty    ? '\nNote: $note'      : ''}',
                    ),
                    isThreeLine: note.isNotEmpty,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _fmtDate(createdAt),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        IconButton(
                          icon: const Icon(Icons.comment_outlined),
                          onPressed: () => _openCommentsSheet(context, postId),
                        ),
                      ],
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

  /// Formats Firestore Timestamp or DateTime
  String _fmtDate(dynamic ts) {
    if (ts == null) return '';
    final d = ts is DateTime ? ts : (ts as Timestamp).toDate();
    return '${d.day}.${d.month}.${d.year}';
  }

  /// Bottom sheet for viewing & adding comments
  void _openCommentsSheet(BuildContext context, String postId) {
    final svc = SocialFeedService();
    final ctrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16, right: 16, top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1) List existing comments
            SizedBox(
              height: 300,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: svc.getComments(postId),
                builder: (ctx, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final comments = snap.data ?? [];
                  if (comments.isEmpty) {
                    return const Center(child: Text('No comments yet.'));
                  }
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (cctx, j) {
                      final c = comments[j];
                      final ts = c['createdAt'];
                      final time = ts is Timestamp
                          ? (ts as Timestamp).toDate()
                          : (ts as DateTime);
                      return ListTile(
                        title: Text(c['username'] ?? 'Anon'),
                        subtitle: Text(c['text'] ?? ''),
                        trailing: Text(
                          '${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const Divider(),

            // 2) Input row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    decoration: const InputDecoration(
                      hintText: 'Write a comment…',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = ctrl.text.trim();
                    if (text.isNotEmpty) {
                      svc.addComment(postId: postId, text: text);
                      ctrl.clear();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
