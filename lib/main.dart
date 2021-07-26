import 'package:flutter/material.dart';
import 'package:notebook/provider/home_page_provider.dart';
import 'package:notebook/screens/home/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomePageProvider>(
      create: ( context) {
        return HomePageProvider();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'note',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage()
      ),
    );
  }
}

