
import 'package:flutter/material.dart';

class CartSummary extends StatelessWidget {
  final title;
  final value;
  final titleSize;
  final valueSize;
  final Color valueColor;
  const CartSummary({
    Key? key,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.titleSize,
    required this.valueSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 10,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: valueSize, fontWeight: FontWeight.bold, color: valueColor),
          ),
        ],
      ),
    );
  }
}