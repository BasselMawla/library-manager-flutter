import 'package:flutter/material.dart';

import '../api_calls.dart';

class StudentRecord extends StatefulWidget {
  final String username, studentName;

  const StudentRecord(this.username, this.studentName, {Key? key})
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
        Map currentBook = borrowedBooks[index];
        String title = currentBook['book_title'].toString();
        String dueDateString = currentBook['due_date'].toString();
        final DateTime dueDate = DateTime.parse(dueDateString);
        bool isLate = dueDate.isBefore(DateTime.now());

        return ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: () async {

                  },
                  icon: const Icon(Icons.replay),
                  tooltip: 'Return book',
                ),
              ),
            ],
          ),
          tileColor: isLate ? Colors.red[200] : Colors.white,
          title: Text(
            title,
            style: _biggerFont,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isLate ? 'Overdue by\n2 days' : '',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text('Due date: ' + dueDateString),
          ),
        );
      },
    );
  }
}
