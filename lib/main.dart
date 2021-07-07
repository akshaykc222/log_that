import 'package:flutter/material.dart';
import 'package:log_that/Providers/DataProvider.dart';
import 'package:log_that/Providers/SubActivityProvider.dart';
import 'package:log_that/Providers/Homepageprovider.dart';

import 'package:log_that/pages/HomePage.dart';
import 'package:log_that/routes.dart';
import 'package:log_that/sqlflite/CategoriesDb.dart';
import 'package:provider/provider.dart';

void main() {
  // MultiProvider(
  //   providers: [
  //     ChangeNotifierProvider(create: (context)=>DatabaseHelper()),
  //     ChangeNotifierProxyProvider<DatabaseHelper,CategoriesProvider>(
  //         create: (context)=>CategoriesProvider([], null),
  //         update: (context,db,previous)=>CategoriesProvider(previous!.items, db)
  //     )
  //   ],
  //   child: MyApp(),
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>HomePageProvider()),
        ChangeNotifierProvider(create: (context)=>SubActivityProvider()),
        ChangeNotifierProvider(create: (context)=>DataProvider())
      ],
      child: MaterialApp(
        title: 'Log that',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        initialRoute: home,
        routes: routes,
      ),
    );
  }
}

