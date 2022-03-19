import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _midSizeFont = const TextStyle(fontSize: 17.0);

  @override
  Widget build(BuildContext context) {
    return Form(
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
            decoration: const InputDecoration(
              hintText: 'Email',
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
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
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
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState!.validate()) {
                    // Process data.
                  }
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
                // Go to register route.
              },
              child: const Text('Register'),
            ),
          )
          // Log in button
        ],
      ),
    );
  }
}
