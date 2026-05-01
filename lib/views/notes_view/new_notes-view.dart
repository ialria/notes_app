import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewNotesPage extends StatefulWidget {
  const NewNotesPage({super.key});

  @override
  State<NewNotesPage> createState() => _NewNotesPageState();
}

class _NewNotesPageState extends State<NewNotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Note"),
      ),
      body: const Text("Write your note here..."),
    );
  }
}
