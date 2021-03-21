import 'package:pennies_from_heaven/models/user.dart';
import 'package:flutter/material.dart';
import 'package:pennies_from_heaven/screens/home/home_page.dart';
import 'package:pennies_from_heaven/screens/sign_in/sign_in_page.dart';

// Builds the signed-in or non-signed-in UI, depending on the user snapshot
// This widget should be below the [MaterialApp].
// An [AuthWidgetBuilder] ancestor is require for this widget to work.

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key, /*required*/ required this.userSnapshot})
      : super(key: key);
  final AsyncSnapshot<User?> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? HomePage() : SignInPage();
    }
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
