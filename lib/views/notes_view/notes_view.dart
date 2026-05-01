import 'package:first/services/auth/auth_service.dart';
import 'package:first/constants/routes.dart';
import 'package:first/services/crud/notes_services.dart';
import 'package:first/views/notes_view/new_notes_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log;

enum MenuAction { logout }

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(context: context, builder: (context) {
    return AlertDialog(
      title: Text("Log out"),
      content: Text("Are you sure you want to Log out?"),
      actions: [
        OutlinedButton(onPressed: () {
          Navigator.of(context).pop(false);
        }, child: Text("Cancel")),
        FilledButton(onPressed: () {
          Navigator.of(context).pop(true);
        }, child: Text("Logout"))
      ],
    );
  },).then((value) => value ?? false,);
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  String get userEmail =>
      AuthService
          .firebase()
          .currentUser!
          .email!;

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
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .primaryContainer,
          actions: [
            IconButton(onPressed: () {
              Navigator.of(context).pushNamed(newNotesRoute);
            }, icon: Icon(Icons.add)),
            PopupMenuButton(
              onSelected: (value) async {
                final shouldLogout = await showLogoutDialog(context);
                if (shouldLogout) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute, (route) => false);
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
        body: FutureBuilder(
            future:_notesServices.getOrCreateUser(email: userEmail),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              else if (
              snapshot.connectionState == ConnectionState.done
              ) {
return StreamBuilder(stream: _notesServices.allNotes, builder:(context, snapshot) {
  if(snapshot.connectionState==ConnectionState.waiting){
    return Center(child: CircularProgressIndicator(),);
  }else if(snapshot.connectionState==ConnectionState.active){
    if(snapshot.hasData){
      final allNotes=snapshot.data as List<DatabaseNote>;
    return ListView.builder(itemCount: allNotes.length,itemBuilder: (context, index) {
      final note=allNotes[index];
return Card(
  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
  child: ListTile(
    title:Text(note.text,
    maxLines: 1,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    ),
  
  ),
);
    },);
    }else{return Center(child: const Text("No data yet"),);
    }
  }else{
    return Center(child: const Text("Something went wrong here"),);
  }

},);
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
                return Center(
                    child: Text("Else case of stream builder"));
              }
            }

        ),
        );
    }

}

