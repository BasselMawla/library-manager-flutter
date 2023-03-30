import 'package:flutter/material.dart';

import '../api_calls.dart';

class BooksList extends StatefulWidget {
  final String? searchQuery;

  const BooksList({this.searchQuery, Key? key}) : super(key: key);
  @override
  State<BooksList> createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map>(
        future: widget.searchQuery == null || widget.searchQuery!.isEmpty
            ? getAllBooks()
            : searchBooks(widget.searchQuery!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildBookListView(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // Show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  ListView buildBookListView(Map booksMap) {
    List booksList = booksMap['books'];
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: booksList.length * 2,
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider(
            thickness: 1.0,
          );
        }

        final index = i ~/ 2; // To ignore dividers
        Map currentBook = booksList[index];
        String title = currentBook['title'].toString();
        String author = currentBook['author'].toString();
        String stockInfo = 'Stock: ' + currentBook['stock'].toString();
        String availableInfo =
            '\nAvailable: ' + currentBook['available'].toString();
        return ListTile(
          leading: const Icon(Icons.book),
          title: Text(
            title,
            style: _biggerFont,
          ),
          trailing: Text(
            stockInfo + availableInfo,
            textAlign: TextAlign.center,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              author,
            ),
          ),
        );
      },
    );
  }
}
