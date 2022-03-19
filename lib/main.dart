import 'package:flutter/material.dart';

import 'api_calls.dart';

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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2679BD),
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
          title: const Text('Coventry University Library'),
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
            const BooksList(),
            if (isLibrarian) const Center(child: Text('STUDENTS')),
            const Center(child: Text('PROFILE')),
          ],
        ),
      ),
    );
  }
}

class BooksList extends StatefulWidget {
  const BooksList({Key? key}) : super(key: key);

  @override
  State<BooksList> createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  late Future<Map> allBooks;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    allBooks = getAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map>(
        future: allBooks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data!);
            return buildBookListView(snapshot.data!);
          } else if (snapshot.hasError) {
            print('ERROR');
            print(snapshot.error);
            return Text('${snapshot.error}');
          }

          // Show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  ListView buildBookListView(Map booksMap) {
    List booksList = booksMap['books'];
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: booksMap['books'].length * 2,
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider(
            thickness: 1.0,
          );
        }

        final index = i ~/ 2; // To ignore dividers
        Map currentBook = booksList[index];
        String bookInfo = currentBook['title'].toString() +
            ' by ' +
            currentBook['author'].toString();
        String stockInfo = ' Stock: ' + currentBook['stock'].toString();
        return ListTile(
          leading: const Icon(Icons.book),
          title: Text(
            bookInfo,
            style: _biggerFont,
          ),
          trailing: Text(
            stockInfo,
          ),
        );
      },
    );
  }
}
