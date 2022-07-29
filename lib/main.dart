import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fundamental2/common/navigation.dart';
import 'package:flutter_fundamental2/common/style.dart';
import 'package:flutter_fundamental2/data/api/api_service.dart';
import 'package:flutter_fundamental2/provider/provider_details.dart';
import 'package:flutter_fundamental2/provider/provider.dart';
import 'package:flutter_fundamental2/provider/provider_search.dart';
import 'package:flutter_fundamental2/ui/detail_page.dart';
import 'package:flutter_fundamental2/ui/home_page.dart';
import 'package:flutter_fundamental2/ui/search_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<RestaurantProvider>(
              create: (_) => RestaurantProvider(apiService: _apiService)),
          ChangeNotifierProvider<SearchProvider>(
            create: (_) => SearchProvider(apiService: _apiService),
          ),
          ChangeNotifierProvider<RestaurantDetailsProvider>(
              create: (_) =>
                  RestaurantDetailsProvider(apiService: _apiService)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Resataurant',
          theme: ThemeData(
              primarySwatch: Colors.grey,
              scaffoldBackgroundColor: Colors.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: myTextTheme,
              appBarTheme: AppBarTheme(titleTextStyle: myTextTheme.headline6)),
          navigatorKey: navigatorKey,
          initialRoute: HomePage.routeName,
          routes: {
            HomePage.routeName: (context) => HomePage(),
            RestaurantSearch.routeName: (context) => const RestaurantSearch(),
            RestaurantDetail.routeName: (context) => RestaurantDetail(
                  restaurant:
                      ModalRoute.of(context)?.settings.arguments as String,
                ),
          },
        ),
      );
}
