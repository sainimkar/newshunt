import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:news_app/services/response_classify.dart';
import 'package:news_app/views/widgets/category_articles_list.dart';
import 'package:news_app/views/widgets/main_scaffold.dart';
import 'package:news_app/views/widgets/shimmer_list.dart';
import 'package:news_app/controllers/news_articles_provider.dart';
import 'package:news_app/views/widgets/close_app_dialoge.dart';
import 'package:news_app/views/widgets/category_button.dart';
import 'package:news_app/views/widgets/home_articles_list_.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  List<String> topics = [
    "general",
    "business",
    "entertainment",
    "health",
    "science",
    "sports",
    "technology",
  ];

  _refreshData(int page) {
    Provider.of<NewsArticlesProvider>(context, listen: false)
        .fetchAllNews(page);
  }

  _onCategoryRefresh(bool isRefresh, String topic) {
    Provider.of<NewsArticlesProvider>(context, listen: false)
        .fetchTopicsNews(isRefresh, topic);
  }

  int page = 1;

  @override
  void initState() {
    _refreshData(page);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewsArticlesProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: (context),
          child: closeAppDialog(context),
        );
      },
      child: SafeArea(
        child: MainScaffold(
            navigationDrawer: true,
            title: "Explore",
            body: Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                // categories list
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: topics.length + 1,
                      padding: EdgeInsets.only(bottom: 15),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return categoryButton(_selectedCategory, index, "ALL",
                              () {
                            if (_selectedCategory != index) {
                              _selectedCategory = index;
                              page = 1;
                              _refreshData(page);
                            }
                          });
                        }
                        return categoryButton(_selectedCategory, index,
                            topics[index - 1].toUpperCase(), () {
                          if (_selectedCategory != index) {
                            _selectedCategory = index;
                            _onCategoryRefresh(false, topics[index - 1]);
                          }
                          setState(() {});
                        });
                      }),
                ),
                // articles
                Expanded(
                  child: Provider.of<NewsArticlesProvider>(context).isLoading
                      // loading shimmer
                      ? ShimmerList()
                      : LiquidPullToRefresh(
                          color: Theme.of(context).primaryColor,
                          springAnimationDurationInMilliseconds: 300,
                          onRefresh: () async {
                            page = 1;
                            _selectedCategory != 0
                                ? _onCategoryRefresh(
                                    true, topics[_selectedCategory - 1])
                                : _refreshData(page);
                          },
                          child: _selectedCategory != 0
                              ? provider.topicsNews.status == Status.ERROR
                                  ? ListView(
                                      children: <Widget>[
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              150,
                                          child: Center(
                                            child: Text(
                                                provider.topicsNews.message),
                                          ),
                                        )
                                      ],
                                    )
                                  : ListView.builder (
                                      itemCount: provider.topicsNews.data.length >
                                              16
                                          ? 18
                                          : provider.topicsNews.data.length + 1,
                                      itemBuilder: (context, index) {
                                        // some Api Articles is duplicated so it is a check to delete this duplication
                                        if (provider
                                                .topicsNews.data[index].title ==
                                            provider.topicsNews.data[index + 1]
                                                .title) {
                                          return SizedBox.shrink();
                                        }
                                        if (index == 0) {
                                          return 
                                              SizedBox.shrink();
                                        }
                                        if (index == 1) {
                                          return orientation !=
                                                  Orientation.landscape
                                              ? Container(
                                                  color: 
                                                      Colors.grey[830],
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, top: 5),
                                                  width: double.infinity,
                                                  child: Text("Top Stories",
                                                      style: TextStyle(
                                                        fontSize: height > 700
                                                            ? 18
                                                            : 16,
                                                      )),
                                                )
                                              : SizedBox.shrink();
                                        }
                                        if (index == 18 ||
                                            index ==
                                                provider.topicsNews.data.length +
                                                    1) {
                                          page++;
                                          _refreshData(page);
                                          return CircularProgressIndicator();
                                        } else {
                                          return CategoryArticleListView(index);
                                        }
                                      },
                                    )
                              : provider.allNews.status == Status.ERROR
                                  ? ListView(
                                      children: <Widget>[
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              150,
                                          child: Center(
                                            child:
                                                Text(provider.allNews.message),
                                          ),
                                        )
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: provider.allNews.data.length >
                                              16
                                          ? 18
                                          : provider.allNews.data.length + 1,
                                      itemBuilder: (context, index) {
                                        // some Api Articles is duplicated so it is a check to delete this duplication
                                        if (provider
                                                .allNews.data[index].title ==
                                            provider.allNews.data[index + 1]
                                                .title) {
                                          return SizedBox.shrink();
                                        }
                                        if (index == 0) {
                                          return 
                                              SizedBox.shrink();
                                        }
                                        if (index == 1) {
                                          return orientation !=
                                                  Orientation.landscape
                                              ? Container(
                                                  color: 
                                                      Colors.grey[830],
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, top: 5),
                                                  width: double.infinity,
                                                  child: Text("Top Stories",
                                                      style: TextStyle(
                                                        fontSize: height > 700
                                                            ? 18
                                                            : 16,
                                                      )),
                                                )
                                              : SizedBox.shrink();
                                        }
                                        if (index == 18 ||
                                            index ==
                                                provider.allNews.data.length +
                                                    1) {
                                          page++;
                                          _refreshData(page);
                                          return CircularProgressIndicator();
                                        } else {
                                          return HomeArticleListView(index);
                                        }
                                      },
                                    ),
                        ),
                ),
              ],
            )),
      ),
    );
  }
}
