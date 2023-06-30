import 'package:flutter/material.dart';

class AddItem extends StatelessWidget {
  final double marginRight;
  const AddItem({
    Key? key,
    this.marginRight = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      margin: EdgeInsets.only(right: marginRight),
      child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add,
            color: Colors.black,
            size: 30,
          )),
    );
  }
}
