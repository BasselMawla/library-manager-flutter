import 'package:cem7052_library/widgets/books_list.dart';
import 'package:cem7052_library/widgets/login.dart';
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
      home: buildHomeTabController(isLibrarian: true),
    );
  }

  DefaultTabController buildHomeTabController({bool isLibrarian = false}) {
    return DefaultTabController(
      length: isLibrarian ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Coventry University Library',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          actions: const [
            Icon(Icons.search),
            Padding(
              // Overflow menu icon with padding
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.more_vert),
            ),
          ],
          bottom: TabBar(
            indicatorColor: const Color(0xFF2679BD),
            tabs: [
              const Tab(text: 'BOOKS', icon: Icon(Icons.book)),
              if (isLibrarian)
                const Tab(text: 'STUDENTS', icon: Icon(Icons.groups)),
              const Tab(text: 'PROFILE', icon: Icon(Icons.account_circle))
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Books tab
            const BooksList(),
            // Students tab, if librarian
            if (isLibrarian) const Center(child: Text('STUDENTS')),
            // Profile tab
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints.tight(const Size(300.0, 300.0)),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: LoginForm(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
