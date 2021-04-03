import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:pennies_from_heaven/models/register_auth_error.dart';
import 'package:pennies_from_heaven/models/sign_in_auth_error.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:pennies_from_heaven/screens/authentication/auth_widget_builder.dart';
import 'package:pennies_from_heaven/common/constants.dart';
import 'package:pennies_from_heaven/services/firebase_auth_service.dart';
import 'package:pennies_from_heaven/services/image_picker_service.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

import 'models/firebase_project_alias.dart';

final getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase project the app is pointing to
  GetIt.I.registerSingleton<FirebaseProjectAlias>(FirebaseProjectAlias());

  // Firebase Auth "register user" error
  GetIt.I.registerSingleton<RegisterAuthError>(RegisterAuthError());

  // Firebase Auth "sign in" error
  GetIt.I.registerSingleton<SignInAuthError>(SignInAuthError());

  FirebaseApp firebaseApp = await Firebase.initializeApp();
  GetIt.I<FirebaseProjectAlias>().setFirebaseProjectAlias(
      firebaseProjectAliases[firebaseApp.options.projectId]);
  print('🟩 🟩 🟩  Firebase Project Alias = ' +
      firebaseProjectAliases[firebaseApp.options.projectId]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
        Provider<ImagePickerService>(create: (_) => ImagePickerService()),
        ChangeNotifierProvider<ValueNotifier<bool>>(
            create: (_) => ValueNotifier<bool>(false)) // avatarLoading toggle
      ],
      child: StreamBuilder<Object?>(
          stream: getIt<FirebaseProjectAlias>().stream$,
          builder: (context, snapshot) {
            return AuthWidgetBuilder(builder: (context, userSnapshot) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: StreamBuilder<Object?>(
                    stream: GetIt.I<FirebaseProjectAlias>().stream$,
                    builder: (context, snapshot) {
                      return Banner(
                        message: '${snapshot.data}',
                        color: '${snapshot.data}' == 'dev'
                            ? Colors.green
                            : Colors.red,
                        location: BannerLocation.topStart,
                        child: MaterialApp(
                          home: Scaffold(
                            appBar: AppBar(
                              title: const Text('Plugin example app'),
                            ),
                            body: Center(
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    child: const Text("start ui"),
                                    onPressed: () async {
                                      print("🟦 🟦 🟦 You are here!");
                                      final providers = [
                                        AuthUiItem.AuthAnonymous,
                                        AuthUiItem.AuthEmail,
                                        AuthUiItem.AuthPhone,
                                        AuthUiItem.AuthApple,
                                        AuthUiItem.AuthGithub,
                                        AuthUiItem.AuthGoogle,
                                        AuthUiItem.AuthMicrosoft,
                                        AuthUiItem.AuthYahoo,
                                      ];

                                      final result =
                                          await FlutterAuthUi.startUi(
                                        items: providers,
                                        tosAndPrivacyPolicy:
                                            TosAndPrivacyPolicy(
                                          tosUrl: "https://www.google.com",
                                          privacyPolicyUrl:
                                              "https://www.google.com",
                                        ),
                                        androidOption: AndroidOption(
                                          enableSmartLock:
                                              false, // default true
                                        ),
                                        // If you need EmailLink mode, please set EmailAuthOption
                                        emailAuthOption: EmailAuthOption(
                                          requireDisplayName:
                                              true, // default true
                                          enableMailLink:
                                              false, // default false
                                          handleURL: '',
                                          androidPackageName: '',
                                          androidMinimumVersion: '',
                                        ),
                                      );
                                      print(result);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            });
          }),
    );
  }
}
