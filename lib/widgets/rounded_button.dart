
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final text;
  final VoidCallback onPressed;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.0,
      child: TextButton(
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: Colors.black, fontSize: 15.0)),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 8.0),
          backgroundColor: Colors.grey.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }
}
