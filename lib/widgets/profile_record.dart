import 'package:flutter/material.dart';

import '../api_calls.dart';

class ProfileRecord extends StatefulWidget {
  final String username;

  const ProfileRecord(this.username, {Key? key}) : super(key: key);

  @override
  State<ProfileRecord> createState() => _ProfileRecordState();
}

class _ProfileRecordState extends State<ProfileRecord> {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map>(
        future: getStudentRecord(widget.username),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List borrowedBooks = snapshot.data!['borrowed_books'];
            if (borrowedBooks.isEmpty) {
              return Center(
                  child: Text('No borrowed books', style: _biggerFont));
            } else {
              return buildStudentRecordView(snapshot.data!);
            }
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // Show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  ListView buildStudentRecordView(Map studentRecord) {
    List borrowedBooks = studentRecord['borrowed_books'];
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: borrowedBooks.length * 2, // Books + dividers
      itemBuilder: (context, i) {
        // If odd, return a divider
        if (i.isOdd) {
          return const Divider(
            thickness: 1.0,
          );
        }

        final index = i ~/ 2; // To ignore dividers
        final Map currentBook = borrowedBooks[index];
        final title = currentBook['title'].toString();
        final dueDateString = currentBook['due_date'].toString();
        final DateTime dueDate = DateTime.parse(dueDateString);
        final bool isLate = dueDate.isBefore(DateTime.now());

        return ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLate
                  ? const Tooltip(
                      message: '2 days late',
                      child: Icon(Icons.info),
                    )
                  : const Icon(Icons.book),
            ],
          ),
          tileColor: isLate ? Colors.red[200] : Theme.of(context).canvasColor,
          title: Text(
            title,
            style: _biggerFont,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Text('Due date: ' + dueDateString + ' '),
              ],
            ),
          ),
        );
      },
    );
  }
}
