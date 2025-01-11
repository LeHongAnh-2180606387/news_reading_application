import 'package:flutter/material.dart';
import 'package:news_reading_application/models/tag_dto.dart';

class Tag extends StatelessWidget {
  final TagDto tag;
  final bool isSelected; // Add isSelected to indicate the selection status
  final VoidCallback onTap;

  const Tag({
    super.key,
    required this.tag,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.blue : Colors.grey, // Highlight selected tags
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tag.id, // Assuming TagDto has a 'name' property
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
