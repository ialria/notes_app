import 'package:first/services/auth/bloc/auth_bloc.dart';
import 'package:first/services/auth/bloc/auth_event.dart';
import 'package:first/services/auth/bloc/auth_state.dart';
import 'package:first/utility_pages/dialog/error_dialog.dart';
import 'package:first/utility_pages/dialog/password_sent_reset_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller=TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async{
if(state is AuthStateForgotPassword){
  if(state.hasSentEmail){
    _controller.clear();
    await showPasswordResetSendDialolg(context);
  }
  
  if(state.exception!=null){
    await showErrorDialog(context: context, text: 'We could not process your request. Please make sure that you are a registered user, or if not, register yourself!');
  }
}
    },
child: Scaffold(
  appBar: AppBar(title: Text("Forgot Password"),
  ),
  body: Padding(padding:EdgeInsets.all(16),
  child: Column(
    children: [
      Text("Enter your email and we will send you a password reset link"),
      TextField(
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        autofocus: true,
        controller:_controller,
        decoration: InputDecoration(
          hintText: 'Your Email Address...'
        ),

      ),
      SizedBox(height: 18,),
      SizedBox(height:48, width:double.infinity,
          child: FilledButton(onPressed: (){
            final email=_controller.text.trim();
            context.read<AuthBloc>().add(AuthEventForgotPassword(email:email));
          }, child: Text("Send Reset link"))),
      TextButton(onPressed: (){
        context.read<AuthBloc>().add(AuthEventShouldLogIn());
      }, child: Text("Back to login page"),
      )],
  ),
  ),
),
    );
  }
}
