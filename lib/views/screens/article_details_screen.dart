import 'package:flutter/material.dart';
import 'package:news_app/Models/news_model.dart';
import 'package:news_app/views/widgets/webview_container.dart';



class ArticleDetails extends StatelessWidget {
  final Article article;

  ArticleDetails(this.article);

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return MaterialApp(
      home: WebViewContainer(
          article.url,
          article.title.length > 20
              ? "${article.title.split(" ")[0]} ${article.title.split(" ")[1]} ${article.title.split(" ")[2]}"
              : article.title),
    );
  }
}
