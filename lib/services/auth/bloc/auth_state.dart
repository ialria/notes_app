import 'package:first/services/auth/auth_user.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:equatable/equatable.dart';
@immutable
abstract class AuthState{
  final bool isLoading;
  final String? loadingText;
  const AuthState({required this.isLoading, this.loadingText='Please wait a moment...'});
}
 class AuthStateUninitialize extends AuthState{
  const AuthStateUninitialize({required super.isLoading});
 }

 class AuthStateRegistering extends AuthState{
  final Exception? exception;
  const AuthStateRegistering({required this.exception, required super.isLoading});
 }

class AuthStateLoggedIn extends AuthState{
  final AuthUser user;
  const AuthStateLoggedIn({required this.user, required super.isLoading});
}


class AuthStateNeedsVerification extends AuthState{
  const AuthStateNeedsVerification({required super.isLoading});
}

class AuthStateForgotPassword extends AuthState{
  final Exception? exception;
  final bool hasSentEmail;
  const AuthStateForgotPassword({required super.isLoading,required this.exception,required this.hasSentEmail});
}

class AuthStateLoggedOut extends AuthState with EquatableMixin{
  final Exception? exception;
  const AuthStateLoggedOut({required this.exception, required super.isLoading, String? loadingText});

  @override
  // TODO: implement props
  List<Object?> get props => [exception, isLoading];
}


//
// class AuthStateLogoutFailure extends AuthState{
//   final Exception exception;
//   const AuthStateLogoutFailure(this.exception);
// }
//
//
// class AuthStateLoading extends AuthState{
//   const AuthStateLoading({required super.isLoading});
// }
////
// // class AuthStateLoginFailure extends AuthState{
// //   final Exception? exception;
// //   const AuthStateLoginFailure({required this.exception, required super.isLoading});
// // }
