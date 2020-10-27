import 'package:flutter/material.dart';
import 'package:news_app/Models/news_model.dart';
import 'package:news_app/controllers/news_api.dart';
import 'package:news_app/services/response_classify.dart';

class NewsArticlesProvider with ChangeNotifier {
  NewsApi _newsApi = NewsApi();
  bool _isLoad = true;
  ResponseClassify<List<Article>> topicsNews;
  ResponseClassify<List<Article>> allNews;

  bool get isLoading {
    print("IsLoading $_isLoad");
    return _isLoad;
  }

  Future fetchAllNews(int page) async {
    try {
      _isLoad = true;
      allNews = await _newsApi.fetchAllNews(page);
    } catch (error) {
      allNews = ResponseClassify.error("Please Try again later");
      print("CATCH $error");
    }
    _isLoad = false;
    notifyListeners();
  }

  Future fetchTopicsNews(bool isRefresh, String topic) async {
    try {
      _isLoad = true;
      topicsNews = await _newsApi.fetchTopicsNews(isRefresh, topic);
    } catch (error) {
      topicsNews = ResponseClassify.error("Please Try again later");
      print("CATCH $error");
    }
    _isLoad = false;
    notifyListeners();
  }
}
