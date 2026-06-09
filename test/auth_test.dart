import 'dart:async';
import 'package:first/services/auth/auth_exceptions.dart';
import 'package:first/services/auth/auth_provider.dart';
import 'package:first/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });
    test("Cannot logout if not initialized", () {
      expect(
        provider.logOut(),
        throwsA(TypeMatcher<InvalidAuthException>()),
      );
    });

    test("Create user", () async {
      expect(provider.isInitialized, false);
    });
    test("After creation user should be null as not verified", () {
      expect(provider.currentUser, null);
    });

    test(
      "Should be able to initialize in less than 2 seconds",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: Timeout(Duration(seconds: 2)),
    );

    test("Test for Login ", () async {
     await  provider.initialize();
      expect(
        () => provider.createUser(
          email: 'abc@gmail.com',
          password: 'anyPassword',
        ),
        throwsA(TypeMatcher<UserNotLoggedInException>()),
      );

      expect(
        () => provider.createUser(email: 'a@gmail.com', password: 'abc'),
        throwsA(TypeMatcher<InvalidAuthException>()),
      );

      final user = await provider.createUser(
        email: '@gmail.com',
        password: 'aaa',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("Login User should be able to verify", () async{
      await provider.initialize();
await provider.createUser(email: 'email', password: 'aaa');
      await provider.sendEmailVerification();
      final user=provider.currentUser;
      expect(user, isNotNull);
        expect(user!.isEmailVerified, true);
    });

    test("User should be able to logout and login again", () async {
      await provider.initialize();
      await provider.createUser(email: '@gmail.com', password: 'aaa');

      await provider.logOut();
       await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
      throw InvalidAuthException();
    }
    await Future.delayed(Duration(seconds: 1));
    final user = await logIn(email: email, password: password);
    if (user == null) {
      throw UserNotLoggedInException();
    }
    return user;
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    // TODO: implement initialize
    await Future.delayed(Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser?> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) {
      throw InvalidAuthException();
    }
    if (email == 'abc@gmail.com') throw UserNotLoggedInException();
    if (password == 'abc') throw InvalidAuthException();
    // test user initialization
    const user = AuthUser(id :'my_id',isEmailVerified: false, email: 'hibasaud18@gmail.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw InvalidAuthException();
    if (_user == null) throw InvalidAuthException();
    await Future.delayed(Duration(seconds: 1));
    // mocking logout
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw InvalidAuthException();
    final user = _user;
    if (user == null) {
      throw UserNotLoggedInException();
    }
    await Future.delayed(Duration(seconds: 1));
    final newUser = AuthUser(id:'my_id',isEmailVerified: true, email: 'hibasaud18@gmail.com');
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    // TODO: implement sendPasswordReset
    throw UnimplementedError();
  }
}
