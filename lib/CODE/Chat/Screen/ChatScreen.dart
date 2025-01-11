import 'package:news_reading_application/CODE/Chat/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_reading_application/CODE/Screen/AuthScreen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _controller = TextEditingController();
  String _enteredMessage = '';
  
void _sendMessage() async {
  FocusScope.of(context).unfocus();
  final user = FirebaseAuth.instance.currentUser;
  final username = user!.displayName ?? 'Unknown';  // Lấy tên người dùng từ FirebaseAuth
  
  await FirebaseFirestore.instance.collection('chat').add({
    'text': _enteredMessage,
    'createdAt': Timestamp.now(),
    'userId': user.uid,
    'username': username,  // Lưu tên người dùng vào Firestore
  });
  _controller.clear();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Chat Firestore'),
            Text(
              'UID: ${FirebaseAuth.instance.currentUser!.uid}',
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: Message(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(labelText: 'Gửi tin nhắn...'),
                    onChanged: (value) {
                      setState(() {
                        _enteredMessage = value;
                      });
                    },
                  ), // TextField
                ), // Expanded
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed:
                      _enteredMessage.trim().isEmpty ? null : _sendMessage,
                ), // IconButton
              ],
            ), // Row
          ), // Padding
        ],
      ),
    );
  }
}