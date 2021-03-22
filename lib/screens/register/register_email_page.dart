import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pennies_from_heaven/models/firebase_project_alias.dart';
import 'package:pennies_from_heaven/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';

class RegisterEmailPage extends StatefulWidget {
  final Function toggleView;

  const RegisterEmailPage({Key? key, required this.toggleView})
      : super(key: key);
  @override
  _RegisterEmailPageState createState() => _RegisterEmailPageState();
}

class _RegisterEmailPageState extends State<RegisterEmailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email = '';
  String? _password = '';
  bool _obscureText = true;
  void _togglePasswordVisiblity() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Future<void> _signInAnonymously(BuildContext context) async {
  //   try {
  //     final auth = context.read<FirebaseAuthService>();
  //     final user = await (auth.signInAnonymously());
  //     print("🟩 🟩 🟩  uid = ${user?.uid}");
  //   } catch (e) {
  //     print("🟥 🟥 🟥  Sign In Anonymously error " + e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            label: Text(
              'Sign In',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              widget.toggleView();
            }, //TODO: Navigate to Sign In screen
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 130.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "email", hintText: "Enter your email"),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        return null;
                      },
                      onChanged: (String? value) {
                        setState(() =>
                            _email = value == null ? value : value.trim());
                      },
                    ),
                    SizedBox(height: 6.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: "Enter your password",
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: _togglePasswordVisiblity,
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onChanged: (String? value) {
                        setState(() =>
                            _password = value == null ? value : value.trim());
                      },
                      obscureText: _obscureText,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print('+++++ email = $_email +++++');
                              print('+++++ password = $_password +++++');
                            }
                          },
                          child: const Text('Register'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: StreamBuilder<Object?>(
                // stream: GetIt.I<BuildFlavor>().stream$,
                stream: GetIt.I<FirebaseProjectAlias>().stream$,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Firebase Project Alias = ${snapshot.data}'),
                  );
                }),
          )
        ],
      ),
    );
  }
}
