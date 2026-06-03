import 'package:first/services/auth/auth_user.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AuthState{
  const AuthState();
}
 class AuthStateUninitialize extends AuthState{
  const AuthStateUninitialize();
 }
 class AuthStateRegistering extends AuthState{
  final Exception? exception;
  const AuthStateRegistering(this.exception);
 }
class AuthStateLoggedIn extends AuthState{
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState{
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState{
  final Exception? exception;
  const AuthStateLoggedOut(this.exception);
}



class AuthStateLoginFailure extends AuthState{
  final Exception exception;
  const AuthStateLoginFailure(this.exception);
}



class AuthStateLogoutFailure extends AuthState{
  final Exception exception;
  const AuthStateLogoutFailure(this.exception);
}


class AuthStateLoading extends AuthState{
  const AuthStateLoading();
}

