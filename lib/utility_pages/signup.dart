import 'package:first/services/auth/auth_exceptions.dart';
import 'package:first/services/auth/auth_service.dart';
import 'package:first/constants/routes.dart';
import 'package:first/services/auth/bloc/auth_bloc.dart';
import 'package:first/services/auth/bloc/auth_event.dart';
import 'package:first/services/auth/bloc/auth_state.dart';
import 'package:first/utility_pages/dialog/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
      listener: (context, state)async {
        if(state is AuthStateRegistering){
          if(state.exception is  GenericAuthException)
            {
              await showErrorDialog(context: context, text: 'Failed to Regster!');
            }
        }

      },
      child: Scaffold(
        body: Padding(
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
                child: FilledButton(
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    if (password.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Password must be at leat 6 characters.",
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Email and password required!"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
context.read<AuthBloc>().add(AuthEventRegisterEvent(email: email, password: password));
                    // try {
                    //   final userCredentials = await AuthService.firebase()
                    //       .createUser(email: email, password: password);
                    //
                    //   AuthService.firebase().sendEmailVerification();
                    //
                    //   // FirebaseAuth.instance.createUserWithEmailAndPassword(
                    //   //     email: email, password: password);
                    //   // print(userCredentials);
                    //
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text("User Registered! "),
                    //       behavior: SnackBarBehavior.floating,
                    //       margin: EdgeInsets.all(24),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //     ),
                    //   );
                    //   Navigator.of(context).pushNamed(verifyEmailRoute);
                    // } on GenericAuthException {
                    //   await showErrorDialog(
                    //     context: context,
                    //     text: "Authentication Error! ",
                    //   );
                    // }
                  },
                  child: Text("Sign up"),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already a user?", style: TextStyle(fontSize: 18)),
                  TextButton(
                    onPressed: () {
                     context.read<AuthBloc>().add(AuthEventLogOut());
                    },
                    child: Text("Login", style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
