import 'package:flutter/material.dart';

import 'books_list.dart';

class SearchList extends StatefulWidget {
  const SearchList({Key? key}) : super(key: key);

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  late String searchQuery;

  @override
  void initState() {
    super.initState();
    searchQuery = "";
  }

  @override
  Widget build(BuildContext context) {
    print('search_list 1: $searchQuery');
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelStyle: TextStyle(color: Colors.white),
            hintText: 'Search for a book...',
            hintStyle: TextStyle(color: Colors.white),
            fillColor: Colors.white12,
            filled: true,
          ),
          autofocus: true,
          cursorColor: Colors.white,
          onChanged: (String value) {
            setState(() {
              searchQuery = value;
            });
            /*setState(() {
                    searchQuery = value;
                    print('home_tab_bar.dart->onChanged->searchQuery: $searchQuery');
                  });*/
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BooksList(searchQuery: searchQuery),
    );
  }
}
