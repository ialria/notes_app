import 'package:first/utility_pages/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showPasswordResetSendDialolg(BuildContext context){
  return showGenericDialog(context: context, title: 'Password Resst', content: 'We have sent you a password reset link. Please check your email for more information', optionBuilder:() => {
    'OK':null,
  },);
}