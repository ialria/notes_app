import 'package:first/services/auth/auth_provider.dart';
import 'package:first/services/auth/bloc/auth_event.dart';
import 'package:first/services/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    // initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;

      if (user == null) {
        emit(const AuthStateLoggedOut(null));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    // login event
    on<AuthEventLogIn>((event, emit) async {
      // emit(AuthStateLoading());
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(email: email, password: password);
        if(user==null){
          emit(AuthStateLoggedOut(null));
        }else{
          emit(AuthStateLoggedIn(user));

        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      // to show outside world that we are doing something
      emit(AuthStateLoading());
      try {
        await provider.logOut();
        emit(AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(AuthStateLogoutFailure(e));
      }
    });
  }
}
