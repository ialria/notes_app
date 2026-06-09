import 'package:first/services/auth/auth_provider.dart';
import 'package:first/services/auth/bloc/auth_event.dart';
import 'package:first/services/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
    : super(AuthStateUninitialize(isLoading: true)) {
    // initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;

      if (user == null) {
        emit(AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user:user, isLoading: false,));
      }
    });

    // login event
    on<AuthEventLogIn>((event, emit) async {
      emit(AuthStateLoggedOut(exception: null, isLoading: true,loadingText: 'Please wait while I log you in'));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(email: email, password: password);

        if (user == null) {
          emit(AuthStateLoggedOut(exception: null, isLoading: false));
        } else {
          if (!user.isEmailVerified) {
            emit(AuthStateLoggedOut(exception: null, isLoading: false));
            emit(AuthStateNeedsVerification(isLoading: false));
          } else {
            emit(AuthStateLoggedOut(exception: null, isLoading: false));
            emit(AuthStateLoggedIn(user:user, isLoading: false));
          }
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    on<AuthEventRegisterEvent>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e,isLoading: false));
      }
    });

    on<AuthEventShouldRegisterEvent>((event, emit) async {
      emit(AuthStateLoggedOut(exception: null, isLoading: false));
      emit(AuthStateRegistering(exception: null,isLoading: false));
    });
  }
}
