import 'package:flutter/material.dart';
import 'package:message_buddy/widgets/constants.dart';

class MyButton extends StatelessWidget {
  final IconData icon;
  final String action;
  final VoidCallback onTap;
  final bool selected;

  const MyButton(
      {super.key,
      required this.icon,
      required this.action,
      required this.onTap,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      selectedColor: Colors.black,
      splashColor: Colors.black,
      onTap: onTap,
      leading: Icon(icon),
      title: Text(
        action,
        style: normalText,
      ),
    );
  }
}
