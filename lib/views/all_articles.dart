import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_reading_application/locator.dart';
import 'package:news_reading_application/models/article_dto.dart';
import 'package:news_reading_application/models/tag_dto.dart';
import 'package:news_reading_application/services/api_service.dart';
import 'package:news_reading_application/theme/style.dart';
import 'package:news_reading_application/views/article_detail.dart';
import 'package:news_reading_application/widgets/list_item.dart';
import 'package:news_reading_application/widgets/search_bar.dart';
import 'package:news_reading_application/widgets/tag_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllArticlesPage extends StatefulWidget {
  const AllArticlesPage({super.key});

  @override
  State<AllArticlesPage> createState() => _AllArticlesPageState();
}

class _AllArticlesPageState extends State<AllArticlesPage> {
  final ApiService _apiService = locator<ApiService>();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<ArticleDto> articles = [];
  List<TagDto> tags = [];
  int _selectedIndex = 0;
  bool _isSearching = false;
  bool _isLoading = false;
  String? _selectedTagId;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _getArticles();
  }

  Future<void> _getArticles() async {
    try {
      setState(() {
        _isLoading = true;
      });
      articles = await _apiService.getArticles(
        _selectedIndex == 0 ? 'news' : 'story',
        _selectedTagId,
      );
      _refreshController.refreshCompleted();
    } catch (e) {
      print('Error fetching articles: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _search(String pattern) async {
    if (_debounce != null && _debounce!.isActive) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (pattern.isEmpty) {
        _getArticles();
        return;
      }

      try {
        setState(() {
          _isLoading = true;
        });
        articles = await _apiService.searchArticles(
          _selectedIndex == 0 ? 'news' : 'story',
          pattern,
        );
        _refreshController.refreshCompleted();
      } catch (e) {
        print('Error searching articles: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
            icon: Icon(_isSearching ? Icons.search_off : Icons.search),
          )
        ],
        title: _isSearching
            ? CustomSearchBar(onChanged: _search)
            : const Text('Best news'),
        bottom: TagBar(
          tags: tags,
          onTagSelected: (TagDto tag) {
            setState(() {
              _selectedTagId = tag.id;
              _getArticles();
            });
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SmartRefresher(
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: _getArticles,
              child: ListView.builder(
                padding: paddingMainView,
                itemCount: articles.length,
                itemBuilder: (BuildContext context, int index) {
                  return ArticleListItem(
                    article: articles[index], // Truyền đối số 'article'
                    onTap: (ArticleDto article) {
                      // Truyền đối số 'onTap'
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ArticleDetail(article: article),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Stories',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _getArticles();
          });
        },
      ),
    );
  }
}
