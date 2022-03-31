import 'package:flutter/material.dart';

import '../api_calls.dart';

class StudentRecord extends StatefulWidget {
  final String username;
  final Function refreshParent;

  const StudentRecord(this.username, {Key? key, required this.refreshParent})
      : super(key: key);

  @override
  State<StudentRecord> createState() => _StudentRecordState();
}

class _StudentRecordState extends State<StudentRecord> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _uuidController = TextEditingController();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _uuidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0, bottom: 8.0, left: 24.0, right: 20.0),
            child: Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400.0),
                      child: TextFormField(
                        controller: _uuidController,
                        decoration: const InputDecoration(
                          //hintText: 'Book UUID',
                          border: OutlineInputBorder(),
                          labelText: 'Book UUID',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a UUID';
                          }
                          if (value.length != 36) {
                            return 'Please enter a valid UUID\n(36 characters, including hyphens)';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 26.0, right: 11.0),
                    child: SizedBox(
                      width: 75.0,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor)),
                        child: const Text('Loan'),
                        onPressed: () async {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState!.validate()) {
                            // Loan book
                            int loanStatusCode = await loanBook(
                                widget.username, _uuidController.text);
                            if (loanStatusCode == 204) {
                              // Successfully loaned
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Book loaned"),
                              ));
                              setState(() {});
                              widget.refreshParent();
                            } else if (loanStatusCode == 409) {
                              // Already borrowed
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Not available! Book already borrowed."),
                              ));
                            } else {
                              // Catch-all errors
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Something went wrong. Please try again later."),
                              ));
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 1.0,
          ),
          Expanded(
            child: FutureBuilder<Map>(
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
          ),
        ],
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
              SizedBox(
                width: 75.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor)),
                  child: const Text('Return'),
                  onPressed: () async {
                    bool isReturned = await returnBook(bookId);
                    if (isReturned) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Book returned"),
                      ));
                      setState(() {});
                      widget.refreshParent();
                    } else {
                      // Catch-all errors
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Something went wrong. Please try again later."),
                      ));
                    }
                  },
                ),
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
