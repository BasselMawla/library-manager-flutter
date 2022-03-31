import 'package:cem7052_library/widgets/search_list.dart';
import 'package:cem7052_library/widgets/students_list.dart';
import 'package:flutter/material.dart';

import '../utils.dart';
import 'add_book.dart';
import 'books_list.dart';
import 'login.dart';

class HomeTabBar extends StatefulWidget {
  const HomeTabBar({Key? key}) : super(key: key);

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> {
  void refresh() {
    print('home_tab_bar.dart->refresh');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getIsLibrarian(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildHomeTabController(snapshot.data!);
        } else if (snapshot.hasError) {
          return buildHomeTabController(false);
        }

        // Show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  DefaultTabController buildHomeTabController(bool isLibrarian) {
    return DefaultTabController(
      length: isLibrarian ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Coventry University Library',
            style: Theme.of(context)
                .textTheme
                .headline1, //TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _pushSearchRoute(context);
              },
            ),
            const Padding(
              // Overflow menu icon with padding
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.more_vert),
            ),
          ],
          bottom: TabBar(
            tabs: [
              const Tab(text: 'BOOKS', icon: Icon(Icons.book)),
              if (isLibrarian)
                const Tab(text: 'STUDENTS', icon: Icon(Icons.groups)),
              const Tab(text: 'PROFILE', icon: Icon(Icons.account_circle))
            ],
          ),
        ),
        body: buildTabViews(isLibrarian),
      ),
    );
  }

  // Build the content inside each tab
  TabBarView buildTabViews(bool isLibrarian) {
    return TabBarView(
      children: [
        // Books tab
        Scaffold(
          body: const BooksList(),
          floatingActionButton: buildAddBookButton(isLibrarian),
        ),

        // Students tab, if librarian
        if (isLibrarian) const StudentsList(),

        // Profile tab
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(const Size(300.0, 300.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LoginForm(refreshParent: refresh),
              // child: if (isLoggedIn) ? ProfileRecord : LoginForm(refreshParent: refresh),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAddBookButton(bool isLibrarian) {
    if (isLibrarian) {
      return FloatingActionButton(
        onPressed: () {
          // Add a book
          _pushAddBookRoute(context);
        },
        tooltip: 'Add a book',
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      );
    }
    return Container();
  }

  // TODO: Finish
  void _pushAddBookRoute(context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add a book'),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: const AddBook(),
          );
        },
      ),
    );
  }

  void _pushSearchRoute(context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) {
        return const SearchList();
      }),
    );
  }
}
