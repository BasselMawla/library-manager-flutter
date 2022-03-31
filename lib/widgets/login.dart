import 'package:flutter/material.dart';

import '../api_calls.dart';
import '../utils.dart';

class LoginForm extends StatefulWidget {
  final Function refreshParent;

  const LoginForm({Key? key, required this.refreshParent}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _midSizeFont = const TextStyle(fontSize: 17.0);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              'Please log in or register',
              style: _midSizeFont,
            ),
          ),
          // Email text field
          TextFormField(
            controller: _emailController,
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
            controller: _passwordController,
            decoration: const InputDecoration(
              hintText: 'Password',
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
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor)),
                child: const Text('Log in'),
                onPressed: () async {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState!.validate()) {
                    await login(
                        _emailController.text, _passwordController.text);
                    String token = await getJwtToken();
                    if (token.isEmpty) {
                      // TODO: Error try again
                    } else {
                      setJwtToken(token);
                      widget.refreshParent();
                    }
                  }
                },
              ),
            ),
          ),
          // Register button
          SizedBox(
            width: 100.0,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor)),
              onPressed: () async {
                // TODO: setState(() {});
                bool isLibrarian = await getIsLibrarian();

                widget.refreshParent(isLibrarian);
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
