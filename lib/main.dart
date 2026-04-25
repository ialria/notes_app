import 'package:firebase_core/firebase_core.dart';
import 'package:first/constants/routes.dart';
import 'package:first/home_page.dart';
import 'package:first/utility_pages/auth_gate.dart';
import 'package:first/utility_pages/login_page.dart';
import 'package:first/utility_pages/signup.dart';
import 'package:first/utility_pages/verify_email.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        loginRoute: (context)=>const LoginPage(),
        signupRoute: (context)=>const SignupPage(),
        homePageRoute: (context)=>const HomePage(),
        authGateRoute: (context)=>const AuthGate(),
        verifyEmailRoute: (context)=>const VerifyEmail(),
      },
      title:"Register app",
        home:AuthGate()
    );
  }
}
