import 'package:first/utility_pages/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCannotShareEmptyDialog(BuildContext context){
return showGenericDialog<void>(context: context, title:"Sharing", content: "Cannot share an empty note!", optionBuilder: () => {
  "OK":null,
},);
}