import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' ;

class Button extends StatelessWidget {
  final String action;
  final Color buttonColor;
  final VoidCallback onPressed;
  final bool bordered;

  const Button(
      {super.key,
      required this.action,
      required this.buttonColor,
      required this.onPressed,
      this.bordered = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(
            32,
          ),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return buttonColor;
              } else if (states.contains(MaterialState.disabled)) {
                return bordered ? Colors.white : buttonColor;
              }
              return bordered ? Colors.white : buttonColor;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(32),
                ),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Center(
            child: Text(
              action,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 13,
                  // fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
