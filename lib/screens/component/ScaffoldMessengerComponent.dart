// ignore_for_file: file_names

import 'package:flutter/material.dart';

scaffoldMessengerComponent(
    {required BuildContext context,
    required String msg,
    required Color color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 500),
    ),
  );
}
