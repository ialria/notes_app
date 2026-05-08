import 'package:first/services/auth/auth_service.dart';
import 'package:first/services/crud/notes_services.dart';
import 'package:first/utility_pages/generics/get_arguments.dart';
import 'package:flutter/material.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  // every time builder gets called new instance of note will be created to ensure that does not happen we create an instance of Database note and hold onto that note to keep track of it not create another one each time
  DatabaseNote? _databaseNote;
  late final NotesServices _notesServices;
  late final TextEditingController _textEditingController;

  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote=context.getArguments<DatabaseNote>();
    if(widgetNote!=null)
      {
        _databaseNote=widgetNote;
        _textEditingController.text=widgetNote.text;
       return widgetNote;
      }

    final existingNote = _databaseNote;
    if (existingNote != null) {
      return existingNote;
    }
    final user = AuthService.firebase().currentUser!;
    final owner = await _notesServices.getUser(email: user.email);

    final newNote = await _notesServices.createNote(owner: owner);
    _databaseNote = newNote;
    return newNote;
  }

  void _deleteNoteIfEmpty() {
    final note = _databaseNote;
    if (_textEditingController.text.isEmpty && note != null) {
      _notesServices.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfNotEmpty() async {
    final note = _databaseNote;
    final text = _textEditingController.text.trim();
    if (note != null && text.isNotEmpty) {
      await _notesServices.updateNote(note: note, text: text);
    }
  }

  void _textControllerListener() async {
    final note = _databaseNote;
    if (note == null) {
      return;
    }
    final text = _textEditingController.text;
    await _notesServices.updateNote(note: note, text: text);
  }

  void _setUpTextControllerListener() async {
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    // TODO: implement initState
    _notesServices = NotesServices();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _deleteNoteIfEmpty();
    _saveNoteIfNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Note")),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final note = snapshot.data as DatabaseNote;
              _databaseNote = note;
              _setUpTextControllerListener();
            }

            return TextField(
              controller: _textEditingController,

              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(hint: Text("Start typing here...")),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
