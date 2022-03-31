import 'package:flutter/material.dart';

import '../api_calls.dart';

class BooksList extends StatefulWidget {
  final String? searchQuery;

  const BooksList({this.searchQuery, Key? key}) : super(key: key);
  @override
  State<BooksList> createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  late Future<Map> booksList;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  /*@override
  void initState() {
    super.initState();
    if (widget.searchQuery == null) {
      booksList = getAllBooks();
    } else {
      booksList = searchBooks(widget.searchQuery!);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    print('books_list.dart->widget.searchQuery: ${widget.searchQuery}');
    return Scaffold(
      body: FutureBuilder<Map>(
        future: widget.searchQuery == null
            ? booksList = getAllBooks()
            : searchBooks(widget.searchQuery!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('snapshot.data: ${snapshot.data}');
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
        String stockInfo = ' Stock: ' + currentBook['stock'].toString();
        return ListTile(
          leading: const Icon(Icons.book),
          title: Text(
            title,
            style: _biggerFont,
          ),
          trailing: Text(
            stockInfo,
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
