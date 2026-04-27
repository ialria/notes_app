import 'package:first/auth/auth_service.dart';
import 'package:first/constants/routes.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log;

enum MenuAction { logout }

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(context: context, builder: (context) {
    return AlertDialog(
      title: Text("Log out"),
      content: Text("Are you sure you want to Log out?"),
      actions: [
        OutlinedButton(onPressed: (){
          Navigator.of(context).pop(false);
        }, child: Text("Cancel")),
        FilledButton(onPressed: (){
          Navigator.of(context).pop(true);

        }, child: Text("Logout"))
      ],
    );
  },).then((value) => value ?? false,);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          PopupMenuButton(
            onSelected: (value)async {
              final shouldLogout=await showLogoutDialog(context);
              if(shouldLogout){
                await AuthService.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute,(route)=>false);
              }
              log(shouldLogout.toString());
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: MenuAction.logout,
                  child: Text("Log out"),
                ),
                PopupMenuItem(child: Text("Rate")),
              ];
            },
          ),
        ],
      ),
      body: Text("Home Page"),

    );
  }
}
