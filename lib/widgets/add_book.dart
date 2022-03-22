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

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please log in or register:',
                  style: _midSizeFont,
                ),
              ),
              // Email text field
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: AutofillHints.email,
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              // Password text field
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: AutofillHints.password,
                ),
                obscureText: true,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: 100.0,
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    child: const Text('Log in'),
                  ),
                ),
              ),
              // Register button
              SizedBox(
                width: 100.0,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text('Register'),
                ),
              )
              // Log in button
            ],
          ),
        ),
      );
  }


}
