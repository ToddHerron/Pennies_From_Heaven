import 'package:rxdart/rxdart.dart';

class SignInAuthError {
  // ignore: close_sinks
  late BehaviorSubject _authError = BehaviorSubject.seeded("");

  Stream get stream$ => _authError.stream;

  String get signInAuthError => _authError.value;

  // add build flavor to the stream
  void setSignInAuthError(String error) {
    _authError.add(error);
  }
}
