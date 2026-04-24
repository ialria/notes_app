import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/home_page.dart';
import 'package:first/utility_pages//signup.dart';
import 'package:first/utility_pages/auth_gate.dart';
import 'package:flutter/material.dart';

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
                      final userCredentials = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                          email: email, password: password);

                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AuthGate()));

                    }on FirebaseAuthException catch (e){
                      if(e.code=='invalid-credential'){
                        // print("Invalid Email/Password");
                      print("Invalid Email/Password");
                      }else if(e.code=="invalid-email"){
                        print("Incorrect email format");
                      }else{
                        print("Login Failed! Try Again");
                      }
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SingupPage()));
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
