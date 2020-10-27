import 'package:flutter/material.dart';
import 'package:news_app/controllers/theme_changer_provider.dart';
import 'package:news_app/controllers/news_articles_provider.dart';
import 'package:news_app/routes.dart';
import 'package:news_app/services/connectivity_service.dart';
import 'package:provider/provider.dart';
main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
        MultiProvider(
        providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => NewsArticlesProvider(),
        ),
        StreamProvider<bool>(
          create: (context) =>
              ConnectivityService().connectionStatusController.stream,
          lazy: false,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeModel>(context).currentTheme,
      title: "NewsMe",
      onGenerateRoute: Routes.routeGenerator,
      initialRoute: "/",
    );
  }
}

