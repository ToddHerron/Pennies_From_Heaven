import 'package:rxdart/rxdart.dart';

class FirebaseProjectAlias {
  // ignore: close_sinks
  late BehaviorSubject _firebaseProjectAlias =
      BehaviorSubject.seeded("No Firebase Project Alias Specified");

  Stream get stream$ => _firebaseProjectAlias.stream;

  String get firebaseProjectAlias => _firebaseProjectAlias.value;

  // add build flavor to the stream
  void setFirebaseProjectAlias(String flavor) {
    _firebaseProjectAlias.add(flavor);
  }
}
