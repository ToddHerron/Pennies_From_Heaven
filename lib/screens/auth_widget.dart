import 'package:pennies_from_heaven/models/user.dart';
import 'package:flutter/material.dart';
import 'package:pennies_from_heaven/screens/home/home_page.dart';
import 'authentication/sign_in/sign_in_page.dart';

// Builds the signed-in or non-signed-in UI, depending on the user snapshot
// This widget should be below the [MaterialApp].
// An [AuthWidgetBuilder] ancestor is require for this widget to work.

class AuthWidget extends StatefulWidget {
  AuthWidget({Key? key, required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User?> userSnapshot;

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userSnapshot.connectionState == ConnectionState.active) {
      return widget.userSnapshot.hasData ? HomePage() : SignInPage();
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
