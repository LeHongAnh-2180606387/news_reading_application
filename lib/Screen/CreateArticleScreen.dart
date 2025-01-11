import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_reading_application/CODE/Service/Article_Service.dart';
import 'dart:io';
// import 'ArticleService.dart';

class CreateArticleScreen extends StatefulWidget {
  @override
  _CreateArticleScreenState createState() => _CreateArticleScreenState();
}

class _CreateArticleScreenState extends State<CreateArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _selectedImage;

  final ArticleService _articleService = ArticleService();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveArticle() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _articleService.saveArticle(
          _titleController.text,
          _summaryController.text,
          _contentController.text,
          _selectedImage,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bài báo đã được lưu thành công!')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Có lỗi xảy ra khi lưu bài báo!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo Bài Báo Mới'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Tiêu Đề'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tiêu đề';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _summaryController,
                  decoration: InputDecoration(labelText: 'Tóm Tắt'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tóm tắt';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: 'Nội Dung'),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập nội dung';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                _selectedImage != null
                    ? Image.file(_selectedImage!, height: 200)
                    : SizedBox(),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Chọn Hình Ảnh'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveArticle,
                  child: Text('Lưu Bài Báo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
