import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:get_it/get_it.dart';
import 'package:pennies_from_heaven/common/constants.dart';
import 'package:pennies_from_heaven/common/loadingSpinner.dart';
import 'package:pennies_from_heaven/models/sign_in_auth_error.dart';
import 'package:pennies_from_heaven/services/firebase_auth_service.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;

  // Text Field state

  String? _email = '';
  String? _password = '';
  bool _emailValidationError = false;
  bool _passwordValidationError = false;

  bool _obscureText = true;
  void _togglePasswordVisiblity() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? LoadingSpinner()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.lightBlue[100],
            appBar: AppBar(
              title: Text('Sign in'),
              elevation: 0.0,
              actions: <Widget>[
                TextButton.icon(
                  label: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    final providers = kIsWeb
                        ? [
                            AuthUiItem.AuthGoogle,
                            AuthUiItem.AuthAnonymous,
                            AuthUiItem
                                .AuthEmail, // AuthPhone CAPTCHA is buggy on the web
                          ]
                        : [
                            AuthUiItem.AuthGoogle,
                            AuthUiItem.AuthAnonymous,
                            AuthUiItem.AuthEmail,
                            AuthUiItem.AuthPhone
                          ];

                    // final providers = [
                    // AuthUiItem.AuthAnonymous,
                    // AuthUiItem.AuthEmail,
                    // AuthUiItem.AuthPhone,
                    // AuthUiItem.AuthApple,
                    // AuthUiItem.AuthGithub,
                    // AuthUiItem.AuthGoogle,
                    // AuthUiItem.AuthMicrosoft,
                    // AuthUiItem.AuthYahoo,
                    // ];

                    await FlutterAuthUi.startUi(
                      items: providers,
                      tosAndPrivacyPolicy: TosAndPrivacyPolicy(
                        tosUrl: "https://www.google.com",
                        privacyPolicyUrl: "https://www.google.com",
                      ),
                      androidOption: AndroidOption(
                        enableSmartLock: false,
                        showLogo: true, // default true
                      ),
                      // If you need EmailLink mode, please set EmailAuthOption
                      emailAuthOption: EmailAuthOption(
                        requireDisplayName: true, // default true
                        enableMailLink: false, // default false
                        handleURL: '',
                        androidPackageName: '',
                        androidMinimumVersion: '',
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 130.0, horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints.loose(const Size(
                                  kIsWeb ? 300 : double.infinity,
                                  kIsWeb ? 60 : double.infinity)),
                              child: TextFormField(
                                decoration: formInputDecoration.copyWith(
                                    labelText: 'Email',
                                    hintText: 'Enter your email address'),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    setState(() {
                                      _emailValidationError = true;
                                    });
                                    GetIt.I<SignInAuthError>()
                                        .setSignInAuthError("");
                                    return 'Please enter your email address';
                                  }
                                  return null;
                                },
                                onChanged: (String? value) {
                                  setState(() => _email =
                                      value == null ? value : value.trim());
                                },
                              ),
                            ),
                          ),
                          _emailValidationError
                              ? SizedBox(height: 9.0)
                              : SizedBox(height: 30.0),
                          Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints.loose(const Size(
                                  kIsWeb ? 300 : double.infinity,
                                  kIsWeb ? 60 : double.infinity)),
                              child: TextFormField(
                                decoration: formInputDecoration.copyWith(
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
                                  if (value == null || value.length < 6) {
                                    setState(() {
                                      _passwordValidationError = true;
                                    });
                                    GetIt.I<SignInAuthError>()
                                        .setSignInAuthError("");
                                    return 'Please enter a password 6+ characters long';
                                  }
                                  return null;
                                },
                                onChanged: (String? value) {
                                  setState(() => _password =
                                      value == null ? value : value.trim());
                                },
                                obscureText: _obscureText,
                              ),
                            ),
                          ),
                          _passwordValidationError
                              ? SizedBox(height: 8.0)
                              : SizedBox(height: 30.0),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // print('+++++ email = $_email +++++');
                                  // print('+++++ password = $_password +++++');
                                  setState(() {
                                    _loading = true;
                                    _emailValidationError = false;
                                    _passwordValidationError = false;
                                  });
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email: _email!, password: _password!);

                                  if (result == null) {
                                    setState(() {
                                      _loading = false;
                                    });
                                  }
                                }
                              },
                              child: const Text('Sign In'),
                            ),
                          ),
                          SizedBox(
                            height: 18.0,
                          ),
                          StreamBuilder<Object?>(
                              stream: GetIt.I<SignInAuthError>().stream$,
                              builder: (context, snapshot) {
                                return Text(
                                    snapshot.data == null
                                        ? ''
                                        : '${snapshot.data}',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 14.0));
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
