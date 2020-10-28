import 'package:flutter/material.dart';
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

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class MyApp extends StatelessWidget {


final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: HexColor("#50afcd"),
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  accentColor: HexColor("#efaa02"),
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: Colors.white54,
);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      title: "NewsMe",
      onGenerateRoute: Routes.routeGenerator,
      initialRoute: "/",
    );
  }
}

