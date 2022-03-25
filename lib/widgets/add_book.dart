import 'package:flutter/material.dart';

import '../api_calls.dart';

class AddBook extends StatefulWidget {
  const AddBook({Key? key}) : super(key: key);

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _midSizeFont = const TextStyle(fontSize: 17.0);

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _isbnController = TextEditingController();
  final _deweyController = TextEditingController();
  int _quantity = 1;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _titleController.dispose();
    _authorController.dispose();
    _isbnController.dispose();
    _deweyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Enter book info',
                style: _midSizeFont,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Book title',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a book title';
                  }
                  return null;
                },
              ),
            ),
            // Password text field
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Primary author',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the primary author';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _isbnController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ISBN',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the primary author';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _deweyController,
                decoration: const InputDecoration(
                  labelText: 'Dewey Classification number',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Dewey Classification number';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Quantity',
                style: _midSizeFont,
              ),
            ),
            // TODO: Drop down loan period
            DropdownButtonFormField(items: const <DropdownMenuItem>[
              DropdownMenuItem(value: 'test1', child: Text('test1')),
              DropdownMenuItem(value: 'test2', child: Text('test2')),
            ], onChanged: null),
            Slider(
              min: 1,
              max: 10,
              value: _quantity.toDouble(),
              divisions: 9,
              label: '${_quantity.round()}',
              onChanged: (value) {
                setState(() {
                  _quantity = value.round();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Scan QR Code', style: _midSizeFont),
                  ),
                  SizedBox(
                    width: 100.0,
                    child: ElevatedButton(
                      child: const Text('Add'),
                      onPressed: () async {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> bookInfo = {
                            'isbn': _isbnController.text,
                            'title': _titleController.text,
                            'author': _authorController.text,
                            'dewey_number': _deweyController.text,
                            'quantity': _quantity,
                          };
                          bool bookWasAdded = await addBook(bookInfo);
                          if(bookWasAdded) {
                            print('Book added successfully');
                            // TODO: Show success message and redirect
                          }
                        } else {
                          // Error
                        }
                      },
                      //child: const Icon(Icons.camera),//const Text('Add'),
                    ),
                  ),SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.lightBlueAccent,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          // Scan QR Code
                        },
                        icon: const Icon(Icons.qr_code),
                        //child: const Icon(Icons.camera),//const Text('Add'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
