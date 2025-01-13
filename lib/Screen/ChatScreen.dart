import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_reading_application/CODE/Chat/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_reading_application/CODE/Service/GoogleSignInService.dart';
import 'package:news_reading_application/Screen/AuthScreen.dart';

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
    final username =
        user!.displayName ?? 'Unknown'; // Lấy tên người dùng từ FirebaseAuth

    await FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': username, // Lưu tên người dùng vào Firestore
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Column(
          children: [
            const Text('Chat Firestore'),
            Text(
              'UID: ${FirebaseAuth.instance.currentUser?.uid ?? 'Unknown'}',
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
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

// Thêm hàm đăng xuất cho cả FirebaseAuth và GoogleSignIn
Future<void> _signOut(BuildContext context) async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  await _googleSignIn.signOut(); // Đăng xuất khỏi Google
  //await FirebaseAuth.instance.signOut(); // Đăng xuất khỏi Firebase
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) => AuthScreen()), // Quay lại màn hình AuthScreen
  );
}
