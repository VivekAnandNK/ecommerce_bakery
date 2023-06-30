import 'package:flutter/material.dart';
import 'package:maharani_bakery_app/models/order.dart';

class CartOperation extends StatelessWidget {
  const CartOperation({
    Key? key,
    required this.context,
    required this.order,
  }) : super(key: key);

  final BuildContext context;
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          border: Border.all(
            width: 1.5,
            color: Theme.of(context).primaryColor,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OperationButton(
            context: context,
            iconData: Icons.remove,
            onPressed: () {
              order.quantity = order.quantity - 1;
            },
          ),
          Text(
            order.quantity.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          OperationButton(
            context: context,
            iconData: Icons.add,
            onPressed: () {
              order.quantity = order.quantity + 1;

            },
          ),
        ],
      ),
    );
  }
}

class OperationButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  const OperationButton({
    Key? key,
    required this.context,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Icon(
          iconData,
          color: Colors.black,
        ));
  }
}
