import 'package:first/utility_pages/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  required String text,
}) {
  return showGenericDialog(
    context: context,
    title: 'An error Occurred!',
    content: text,
    optionBuilder: () => {'OK': null},
  );
}
