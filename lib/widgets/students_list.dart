import 'package:cem7052_library/widgets/student_record.dart';
import 'package:flutter/material.dart';

import '../api_calls.dart';

class StudentsList extends StatefulWidget {
  const StudentsList({Key? key}) : super(key: key);

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map>(
        future: getAllStudents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildStudentListView(snapshot.data!);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // Show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  ListView buildStudentListView(Map studentsMap) {
    List studentsList = studentsMap['students'];
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: studentsList.length * 2,
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider(
            thickness: 1.0,
          );
        }

        final index = i ~/ 2; // To ignore dividers
        Map currentStudent = studentsList[index];
        String username = currentStudent['username'].toString();
        String studentName = currentStudent['first_name'].toString() +
            ' ' +
            currentStudent['last_name'].toString();

        int borrowingCount = currentStudent['borrowing_count'] ?? 0;
        String borrowingString = 'Borrowing:\n  ' +
            borrowingCount.toString() +
            (borrowingCount == 1 ? ' book' : ' books');

        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(
            studentName,
            style: _biggerFont,
          ),
          trailing: Text(
            borrowingString,
          ),
          onTap: () {
            _pushStudentRoute(context, username, studentName);
          },
        );
      },
    );
  }

  void _pushStudentRoute(context, String username, String studentName) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Borrowing Record'),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: StudentRecord(username, studentName, refreshParent: refresh),
          );
        },
      ),
    );
  }
}
