import 'package:first/services/crud/notes_services.dart';
import 'package:first/utility_pages/dialog/show_delete_dialog.dart';
import 'package:flutter/material.dart';

typedef DeleteNoteCallBack =void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> allNotes;
  final DeleteNoteCallBack onDeleteNote;
  const NotesListView({super.key, required this.allNotes, required this.onDeleteNote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: allNotes.length,itemBuilder:  (context, index) {
      final note=allNotes[index];
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
        child: ListTile(
          title:Text(note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
trailing: IconButton(onPressed: ()async{
  final shouldDelete=await showDeleteDialog(context);
  if(shouldDelete){
    onDeleteNote(note);
  }
}, icon:Icon(Icons.delete)),
        ),
      );
    },);
  }
}
