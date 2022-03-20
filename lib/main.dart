import 'package:cem7052_library/widgets/home_tab_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final colorPrimary = const Color(0xFF2679BD);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coventry University Library',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: colorPrimary,
        ),
      ),
      home: const HomeTabBar(),
    );
  }
}