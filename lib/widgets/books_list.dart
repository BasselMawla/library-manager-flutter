import 'package:flutter/material.dart';

import '../api_calls.dart';

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
            return buildBookListView(snapshot.data!);
          } else if (snapshot.hasError) {
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
