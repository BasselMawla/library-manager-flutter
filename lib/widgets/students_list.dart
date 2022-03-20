import 'package:flutter/material.dart';

import '../api_calls.dart';

class StudentsList extends StatefulWidget {
  const StudentsList({Key? key}) : super(key: key);

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  late Future<Map> allStudents;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    allStudents = getAllStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map>(
        future: allStudents,
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
        String name = currentStudent['first_name'].toString() +
            ' ' +
            currentStudent['last_name'].toString();

        int borrowingCount = currentStudent['borrowing_count'] ?? 0;
        String borrowingString = 'Borrowing:\n  ' +
            borrowingCount.toString() +
            (borrowingCount == 1 ? ' book' : ' books');

        return ListTile(
          leading: const Icon(Icons.person),
          title: Text(
            name,
            style: _biggerFont,
          ),
          trailing: Text(
            borrowingString,
          ),
        );
      },
    );
  }
}
