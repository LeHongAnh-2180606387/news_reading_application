import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;  // Thay đổi userId thành username
  final DateTime timestamp;

  const MessageBubble(this.message, this.isMe, this.username, this.timestamp, {super.key});

  String _formatTimestamp (DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '$hour: $minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatTimestamp(timestamp);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.blue[300] : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: 250,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                username,  // Hiển thị username thay vì userId
                style: const TextStyle(
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                message,
                style: const TextStyle(color: Colors.black, fontSize: 17),
              ),
              const SizedBox(height: 8),
              Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
