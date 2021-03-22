import 'package:flutter/material.dart';

const Map firebaseProjectAliases = {
  'pennies-from-heaven---de-fe0ac': 'dev',
  'pennies-from-heaven': 'prod'
};

const formInputDecoration = InputDecoration(
    labelText: "Email",
    hintText: "Enter your email",
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2.0)));
