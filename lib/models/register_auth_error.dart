import 'package:rxdart/rxdart.dart';

class RegisterAuthError {
  // ignore: close_sinks
  late BehaviorSubject _authError = BehaviorSubject.seeded("");

  Stream get stream$ => _authError.stream;

  String get registerAuthError => _authError.value;

  // add build flavor to the stream
  void setRegisterAuthError(String error) {
    _authError.add(error);
  }
}
