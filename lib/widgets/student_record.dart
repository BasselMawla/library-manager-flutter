import 'package:flutter/material.dart';

import '../api_calls.dart';

// TODO: Add textbox for borrowing with UUID of book

class StudentRecord extends StatefulWidget {
  final String username, studentName;
  final Function refreshParent;

  const StudentRecord(this.username, this.studentName,
      {Key? key, required this.refreshParent})
      : super(key: key);

  @override
  State<StudentRecord> createState() => _StudentRecordState();
}

class _StudentRecordState extends State<StudentRecord> {
  late Future<Map> studentRecord;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    studentRecord = getStudentRecord(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map>(
        future: studentRecord,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildStudentRecordView(snapshot.data!);
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
      
      itemCount: borrowedBooks.length * 2,
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider(
            thickness: 1.0,
          );
        }

        final index = i ~/ 2; // To ignore dividers
        final Map currentBook = borrowedBooks[index];
        final bookId = currentBook['book_id'].toString();
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
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Return'),
                onPressed: () async {
                  bool isReturned = await getBook(bookId);
                  if (isReturned) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Book returned"),
                    ));
                    // TODO: Refresh the list of books, and the parent list of students
                    setState(() {});
                  } else {
                    // TODO: Error
                  }
                },
              ),
            ],
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
