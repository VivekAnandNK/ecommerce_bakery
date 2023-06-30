import 'package:flutter/material.dart';

class VerticalDividerWidget extends StatelessWidget {
  VerticalDividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      color: Colors.black12.withOpacity(0.2),
      thickness: 1,
      width: 1,
    );
  }
}
