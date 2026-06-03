import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent{
const AuthEvent();
}

class AuthEventInitialize extends AuthEvent{
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent{
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

class AuthEventLogOut extends AuthEvent{
  const AuthEventLogOut();
}

class AuthEventNeedsEmailVerification extends AuthEvent{
  const AuthEventNeedsEmailVerification();
}

class AuthEventRegisterEvent extends AuthEvent{
  final String email;
  final String password;

 const  AuthEventRegisterEvent({required this.email,required this.password});

}

class AuthEventShouldRegisterEvent extends AuthEvent{
  const AuthEventShouldRegisterEvent();
}
