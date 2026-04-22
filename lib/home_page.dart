import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void checkEmailVerification(){
    final user=FirebaseAuth.instance.currentUser;
    print("Current user: $user");
    if(user?.emailVerified ?? false){
      print("Email verified");
    }else{
      print("Email not verified");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkEmailVerification();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    appBar: AppBar(
    title: Text("Home"),
    ),
  body: Text("Home Page"),
    );
  }
}
