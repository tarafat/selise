import 'package:flutter/material.dart';

class CustomSnackbar {
  BuildContext context;
  String content;
  Color backgroundColor;
  CustomSnackbar(
      {required this.context,
      required this.content,
      required this.backgroundColor});
  showSnackBar() {
    SnackBar snackBar = SnackBar(
      content: Text(content),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
