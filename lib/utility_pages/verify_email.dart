import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first/home_page.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: ()async{
              await FirebaseAuth.instance.currentUser?.reload();
              final user=FirebaseAuth.instance.currentUser;
              if(user!=null && user.emailVerified){
Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(),));
              }
              else{
               await user?.sendEmailVerification();
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text("Verification email sent")),
               );
              }
            }, child: Text("Verify Email",style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700
            ),)),
TextButton.icon(onPressed: ()async{
  await FirebaseAuth.instance.currentUser?.reload();

  final user = FirebaseAuth.instance.currentUser;

  if(user != null && user.emailVerified){

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage()),
    );

  } else {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Email not verified yet")),
    );

  }

}, label: Text("I verified"),icon: Icon(Icons.arrow_right_alt))
          ],
        )

      )
      ,
    );
  }



}
