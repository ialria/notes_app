import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/constants/routes.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _auth_gate();
    });
  }

  void _auth_gate() async{
    await FirebaseAuth.instance.currentUser?.reload();
    if(!mounted) return;
    final user=FirebaseAuth.instance.currentUser;
    if(user==null){
      Navigator.of(context).pushNamed(loginRoute,);
    }else{
      if(!user.emailVerified){

        Navigator.of(context).pushReplacementNamed(verifyEmailRoute);
      }else
        Navigator.of(context).pushReplacementNamed(notesRoute);

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
