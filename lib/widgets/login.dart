import 'package:cem7052_library/widgets/profile_record.dart';
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
    // Clean up the controllers when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getUsername(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // Logged in, show profile (borrowing record)
          return ProfileRecord(snapshot.data!);
        } else {
          // Not logged in, show login form
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints.tight(const Size(300.0, 300.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: buildLoginForm(context),
              ),
            ),
          );
        }
      },
    );
  }

  Form buildLoginForm(BuildContext context) {
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
                    int loginStatusCode = await login(
                        _emailController.text, _passwordController.text);
                    if (loginStatusCode == 200) {
                      // Success
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Logged in successfully!"),
                      ));
                      setState(() {});
                      widget.refreshParent();
                    } else if (loginStatusCode == 403) {
                      // Not found
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Wrong username or password!"),
                      ));
                    } else if (loginStatusCode == 404) {
                      // Not found
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Username does not exits."),
                      ));
                    }else {
                      // Catch-all errors
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Something went wrong. Please try again later."),
                      ));
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
