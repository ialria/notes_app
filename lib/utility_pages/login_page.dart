import 'package:first/services/auth/auth_exceptions.dart';
import 'package:first/services/auth/bloc/auth_bloc.dart';
import 'package:first/services/auth/bloc/auth_event.dart';
import 'package:first/services/auth/bloc/auth_state.dart';
import 'package:first/utility_pages/dialog/error_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
if(state is AuthStateLoggedOut){
          if (state.exception is InvalidAuthException) {
            await showErrorDialog(
              context: context,
              text: 'Invalid! Could not find any match for entered credentials',
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context: context,
              text: 'Invalid! Could not find user with entered credentials',
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context: context,
              text: 'Authentication Error!',
            );
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email"),
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
                        isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 42),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                    // wrap button with bloc listener
                    child: FilledButton(
                      onPressed: (){
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();
                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Email and password required"),
                            ),
                          );
                          return;
                        }
                        context.read<AuthBloc>().add(
                          AuthEventLogIn(email, password),
                        );

                        // try {
                        //              context.read<AuthBloc>().add(AuthEventLogIn(email, password));
                        //
                        // }on InvalidAuthException{
                        //   // if(e.code=='invalid-credential'){
                        //     //   // print("Invalid Email/Password");
                        //     //   ScaffoldMessenger.of(context).showSnackBar(
                        //     //       SnackBar(content: Text("Invalid! Email or Password"))
                        //     //   );
                        //     // log("Invalid Email/Password");
                        //   await showErrorDialog(context:context, text:"Invalid Email/Password");
                        //
                        // }on InvalidEmailAuthException {
                        //   await showErrorDialog(context:context, text:"Invalid Email format");
                        // }on GenericAuthException {
                        //   await showErrorDialog(
                        //       context: context, text:"Authentication Error!\nLogin Failed. Try Again");
                        // }
                      },

                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text("Login"),
                    ),

                ),
                SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: (){
                    context.read<AuthBloc>().add(AuthEventForgotPassword());
                  }, child: Text("Forgot Password?")),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New user?", style: TextStyle(fontSize: 18)),
                    TextButton(
                      onPressed: () {
                       context.read<AuthBloc>().add(AuthEventShouldRegisterEvent());
                      },
                      child: Text("Signup", style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
