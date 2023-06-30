import 'package:flutter/material.dart';

import '../data/data.dart';

class ProgressDialog extends StatelessWidget {

  final brandgreenCreateMaterialColor = Color(0xffdac48c);
  final brandblackCreateMaterialColor = Color(0xFF524a4f);

  String message = "";
  ProgressDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: brandgreenCreateMaterialColor, // Brand Green
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Row(
            children: [
              SizedBox(width: 15.0,),
              CircularProgressIndicator(color: brandGold,),
              SizedBox(width: 16.0,),
              Expanded(
                flex: 3,
                child: Text(
                  message,
                  style: TextStyle(color: brandGold, fontSize: 14.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
