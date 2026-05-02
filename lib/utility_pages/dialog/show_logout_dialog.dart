import 'package:first/utility_pages/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(context: context, title: 'Logout', content:'Are you sure you want to Logout?', optionBuilder: ()=>{
    'Logout':true,
    'Cancel':false,
  },).then((value)=>value ?? false);
}