import 'package:library_manager/widgets/search_list.dart';
import 'package:library_manager/widgets/students_list.dart';
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String username = snapshot.data!['username'];
          if (username.isNotEmpty) {
            return buildHomeTabController(true, snapshot.data!['isLibrarian']);
          } else {
            return buildHomeTabController(false, snapshot.data!['isLibrarian']);
          }
        } else if (snapshot.hasError) {
          return buildHomeTabController(false, false);
        }

        // Show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  DefaultTabController buildHomeTabController(
      bool isLoggedIn, bool isLibrarian) {
    return DefaultTabController(
      length: isLibrarian ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'University Library',
            style: Theme.of(context)
                .textTheme
                .headline1, //TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  _pushSearchRoute(context);
                },
              ),
            ),
            if (isLoggedIn)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: PopupMenuButton(
                  offset: const Offset(-10, 45),
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      height: 0,
                      child: const Text('Log out'),
                      onTap: () async {
                        await logOut();

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Logged out"),
                        ));
                        setState(() {});
                      },
                    ),
                  ],
                ),
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
        LoginForm(refreshParent: refresh),
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
