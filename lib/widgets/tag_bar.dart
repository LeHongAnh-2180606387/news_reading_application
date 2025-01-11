import 'package:flutter/material.dart';
import 'package:news_reading_application/models/tag_dto.dart';
import 'package:news_reading_application/widgets/tag.dart';

class TagBar extends StatelessWidget implements PreferredSizeWidget {
  final List<TagDto> tags;
  final Function(TagDto tag) onTagSelected;
  final String? selectedTagId; // Cần thêm một trường để theo dõi tag được chọn

  const TagBar({
    super.key,
    required this.tags,
    required this.onTagSelected,
    this.selectedTagId, // Thêm tham số này để lưu id của tag đang được chọn
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      height: 50,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final tag in tags)
              Tag(
                tag: tag, // Sử dụng TagDto
                isSelected: selectedTagId ==
                    tag.id, // So sánh id để xác định tag được chọn
                onTap: () => onTagSelected(tag), // Truyền TagDto vào onTap
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
