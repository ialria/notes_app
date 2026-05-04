import 'package:first/services/auth/auth_service.dart';
import 'package:first/constants/routes.dart';
import 'package:first/services/crud/notes_services.dart';
import 'package:first/views/notes_view/notes_list_view.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log;

import '../../utility_pages/dialog/show_logout_dialog.dart';

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userEmail => AuthService.firebase().currentUser!.email!;

  late final NotesServices _notesServices;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notesServices = NotesServices();
    _notesServices.open();
  }

  //don't close each time build is called not calling dispose

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: Icon(Icons.add),
          ),
          PopupMenuButton(
            onSelected: (value) async {
              final shouldLogout = await showLogoutDialog(context);
              if (shouldLogout) {
                await AuthService.firebase().logOut();
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }
              log(shouldLogout.toString());
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(value: MenuAction.logout, child: Text("Log out")),
                PopupMenuItem(child: Text("Rate")),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _notesServices.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
              stream: _notesServices.allNotes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    final allNotes = snapshot.data as List<DatabaseNote>;
                    return NotesListView(
                      allNotes: allNotes,
                      onDeleteNote: (note) async {
                        await _notesServices.deleteNote(id: note.id);
                      },
                      onTap: (note){
                       Navigator.of(context).pushNamed(createOrUpdateNoteRoute,
                       arguments: note);
                      },
                    );
                  } else {
                    return Center(child: const Text("No data yet"));
                  }
                } else {
                  return Center(child: const Text("Something went wrong here"));
                }
              },
            );
          }
          // else if (snapshot.connectionState == ConnectionState.done) {
          //   return StreamBuilder(stream: _notesServices.allNotes,
          //       builder: (context, snapshot) {
          //         if (snapshot.connectionState == ConnectionState.waiting) {
          //           return Center(
          //             child: Text("Waiting for notes to load"),);
          //         } else
          //         if (snapshot.connectionState == ConnectionState.done) {
          //           return Center(child: CircularProgressIndicator(),
          //           );
          //         }
          else {
            return Center(child: Text("Else case of stream builder"));
          }
        },
      ),
    );
  }
}
