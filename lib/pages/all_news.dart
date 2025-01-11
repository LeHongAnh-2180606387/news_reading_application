import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_reading_application/models/article_model.dart';
import 'package:news_reading_application/models/slider_model.dart';
import 'package:news_reading_application/pages/article_view.dart';
import 'package:news_reading_application/services/news.dart';
import 'package:news_reading_application/services/slider_data.dart';

class AllNews extends StatefulWidget {
  String news;
  AllNews({required this.news});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  List<sliderModel> sliders = [];
  List<ArticleModel> articles = [];
  bool _loading = true;
  bool loading2 = true;
  void initState() {
    getSlider();
    getNews();
    super.initState();
  }

  Future<void> getSlider() async {
    Sliders slider = Sliders();
    await slider.getSlider();
    if (slider.sliders.isNotEmpty) {
      sliders = slider.sliders;
    } else {
      print("No sliders available");
    }
    setState(() {
      loading2 = false;
    });
  }

  Future<void> getNews() async {
    News newsclass = News();
    await newsclass.getNews();
    if (newsclass.news.isNotEmpty) {
      articles = newsclass.news;
    } else {
      print("No articles available");
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.news + " News",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount:
                widget.news == "Breaking" ? sliders.length : articles.length,
            itemBuilder: (context, index) {
              if (widget.news == "Breaking" && sliders.isNotEmpty) {
                return AllNewsSection(
                  Image: sliders[index].urlToImage!,
                  desc: sliders[index].description!,
                  title: sliders[index].title!,
                  url: sliders[index].url!,
                );
              } else if (articles.isNotEmpty) {
                return AllNewsSection(
                  Image: articles[index].urlToImage!,
                  desc: articles[index].description!,
                  title: articles[index].title!,
                  url: articles[index].url!,
                );
              } else {
                return Center(child: Text("No data available"));
              }
            }),
      ),
    );
  }
}

class AllNewsSection extends StatelessWidget {
  String Image, desc, title, url;
  AllNewsSection(
      {required this.Image,
      required this.desc,
      required this.title,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)));
      },
      child: Container(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: Image,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              title,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              desc,
              maxLines: 3,
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
