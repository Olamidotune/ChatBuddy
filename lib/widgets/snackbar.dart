import 'package:flutter/material.dart';

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
          label: 'Ok', textColor: Colors.black, onPressed: () {}),
    ),
  );
}
