import 'package:first/services/auth/auth_exceptions.dart';
import 'package:first/services/auth/auth_service.dart';
import 'package:first/constants/routes.dart';
import 'package:first/utility_pages/auth_gate.dart';
import 'package:first/utility_pages/dialog/error_dialog.dart';
import 'package:flutter/material.dart';
// import 'dart:developer' show log;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool isPasswordHidden = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email"
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: isPasswordHidden,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                        icon: Icon(
                          isPasswordHidden ? Icons.visibility_off : Icons
                              .visibility,
                        ),
                      )
                  ),
                ),
                SizedBox(height: 42),
                SizedBox(height: 48,
                  width: double.infinity,
                  child: FilledButton(onPressed: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    if(email.isEmpty || password.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Email and password required"))
                      );
                      return;
                    }

                    try {

                     final user=AuthService.firebase().currentUser;
                     if(user!=null){
                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AuthGate()));
                     }


                    }on InvalidAuthException{
                      // if(e.code=='invalid-credential'){
                        //   // print("Invalid Email/Password");
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(content: Text("Invalid! Email or Password"))
                        //   );
                        // log("Invalid Email/Password");
                      await showErrorDialog(context:context, text:"Invalid Email/Password");

                    }on InvalidEmailAuthException {
                      await showErrorDialog(context:context, text:"Invalid Email format");
                    }on GenericAuthException {
                      await showErrorDialog(
                          context: context, text:"Authentication Error!\nLogin Failed. Try Again");
                    }



                  }, child: Text("Login"),
                    style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)
                        )
                    ),),
                ),
                SizedBox(height: 18,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text("New user?",
                    style: TextStyle(fontSize: 18),),
                    TextButton(onPressed: (){
                      Navigator.of(context).pushNamed(signupRoute);
                    }, child:Text("Signup" , style: TextStyle(fontSize: 18)))
                  ],
                )
              ],
            ),
          ),
        )
    );
  }
}
