import 'package:flutter/material.dart';

Future<void> show_ErrorDialog(BuildContext context,String text,) {
  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Text("An Error Occured!"),
      content: Text(text),
      actions: [
        OutlinedButton(onPressed: (){
          Navigator.of(context).pop();
        }, child:Text("OK"))
      ],
    );

  },);
}