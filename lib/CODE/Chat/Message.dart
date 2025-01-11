import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_reading_application/CODE/Chat/MessageBubble.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  Map<String, String> usernameCache = {}; // Lưu trữ username đã tải về

  Future<String> getUsername(String userId) async {
    if (usernameCache.containsKey(userId)) {
      return usernameCache[userId]!;
    }
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final username = userDoc['username'] ?? 'Unknown';
        usernameCache[userId] = username; // Lưu username vào cache
        return username;
      } else {
        usernameCache[userId] = 'Unknown';
        return 'Unknown';
      }
    } catch (e) {
      usernameCache[userId] = 'Unknown';
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Vòng loading duy nhất
        }

        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) {
            final userId = chatDocs[index]['userId'];
            return FutureBuilder<String>(
              future: getUsername(userId),
              builder: (ctx, usernameSnapshot) {
                if (usernameSnapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(); // Không cần vòng loading cho từng tin nhắn
                }
                final username = usernameSnapshot.data ?? 'Unknown';
                return MessageBubble(
                  chatDocs[index]['text'],
                  userId == FirebaseAuth.instance.currentUser!.uid,
                  username,
                  (chatDocs[index]['createdAt'] as Timestamp).toDate(),
                );
              },
            );
          },
        );
      },
    );
  }
}
