import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth,FirebaseAuthException;
import 'package:first/auth/auth_exceptions.dart';
import 'package:first/auth/auth_provider.dart';
import 'auth_user.dart';

class FirebaseAuthProvider implements AuthProvider{

 @override
AuthUser? get currentUser{
final user= FirebaseAuth.instance.currentUser;
if(user!=null){
  return AuthUser.fromFirebase(user);
}else{
  return null;
}
 }

@override
Future<AuthUser?> logIn({required String email, required String password}) async {
try{
 await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
 final user=currentUser;

} on FirebaseAuthException catch (e){
  if(e.code=='invalid-credential'){
  throw InvalidAuthException();
  }else if(e.code=="invalid-email"){
  throw InvalidEmailAuthException();

  }else{
    // generic exception
  throw GenericAuthException();

  }
}catch (e){
throw GenericAuthException();
}
}

@override
  Future<AuthUser> createUser({required String email, required String password}) async {
   try{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email,
        password: password);
final user=currentUser;
if(user!=null){
  return user;
}
else{
  throw UserNotLoggedInException();
}

   }on FirebaseAuthException catch (e){
throw GenericAuthException();
   } catch (e){
throw GenericAuthException();
   }
}
@override
Future<void> logOut()async {
final user= FirebaseAuth.instance.currentUser;
if(user!=null){
  await FirebaseAuth.instance.signOut();
}else{
  throw UserNotLoggedInException();
}
 }
@override
Future<void> sendEmailVerification()async {
final user =await FirebaseAuth.instance.currentUser;
if(user!=null){
  await user.sendEmailVerification();
}else{
  throw UserNotLoggedInException();
}
 }

}
