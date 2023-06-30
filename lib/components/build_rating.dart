import 'package:flutter/material.dart';

// This Widget is to implement the UI of rating stars 
class Rating extends StatelessWidget {
  final rating;
  const Rating({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // For loop for the bright rating stars
        for (int i = 0; i < rating; i++)
          Icon(
            Icons.star,
            size: 20,
            color: Colors.black,
          ),
        // For loop for the dim stars to keep up 5 star
        for (int i = 0; i < (5 - rating); i++)
          // Here (5-rating) to get the number of dim stars
          Icon(
            Icons.star,
            size: 20,
            color: Colors.black26,
          )
      ],
    );
  }
}
