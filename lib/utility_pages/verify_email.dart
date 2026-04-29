import 'package:first/services/auth/auth_service.dart';
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
              final user=AuthService.firebase().currentUser;
              if(user!=null && user.isEmailVerified){
Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(),));
              }
              else{
             AuthService.firebase().sendEmailVerification();
              }
            }, child: Text("Verify Email",style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700
            ),)),
TextButton.icon(onPressed: ()async{

  final user=AuthService.firebase().currentUser;
  final isVerified=user?.isEmailVerified ?? false;

  if(isVerified){

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
