import 'package:first/services/auth/auth_service.dart';
import 'package:first/services/auth/bloc/auth_bloc.dart';
import 'package:first/services/auth/bloc/auth_event.dart';
import 'package:first/views/notes_view/notes_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
               context.read<AuthBloc>().add(AuthEventSendEmailVerification());
              },
              child: Text(
                "Verify Email",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
            ),
            TextButton.icon(
              onPressed: (){
                context.read<AuthBloc>().add(AuthEventLogOut());
              },
              label: Text("I verified"),
              icon: Icon(Icons.arrow_right_alt),
            ),
          ],
        ),
      ),
    );
  }
}
