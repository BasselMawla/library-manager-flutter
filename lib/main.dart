import 'package:library_manager/widgets/home_tab_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coventry University Library',
      theme: ThemeData(
        //brightness: Brightness.dark,
        primaryColor: const Color(0xFF0066CB),
        indicatorColor: Colors.white,
        //fontFamily: 'Georgia',
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
          // bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: const HomeTabBar(),
    );
  }
}
