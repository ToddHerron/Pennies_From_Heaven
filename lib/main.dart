import 'package:pennies_from_heaven/screens/auth_widget.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:pennies_from_heaven/screens/auth_widget_builder.dart';
import 'package:pennies_from_heaven/common/constants.dart';
import 'package:pennies_from_heaven/services/firebase_auth_service.dart';
import 'package:pennies_from_heaven/services/image_picker_service.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

import 'models/firebase_project_alias.dart';

final getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton<FirebaseProjectAlias>(FirebaseProjectAlias());
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  GetIt.I<FirebaseProjectAlias>().setFirebaseProjectAlias(
      firebaseProjectAliases[firebaseApp.options.projectId]);
  print('🟩 🟩 🟩  Firebase Project       = ${firebaseApp.options.projectId}');
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
              return MaterialApp(
                theme: ThemeData(primarySwatch: Colors.indigo),
                home: SafeArea(
                  child: AuthWidget(
                    userSnapshot: userSnapshot,
                  ),
                ),
              );
            });
          }),
    );
  }
}
