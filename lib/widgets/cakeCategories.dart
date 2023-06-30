// import 'dart:math';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:maharani_bakery_app/components/build_rating.dart';
// import 'package:maharani_bakery_app/data/data.dart';
// import 'package:maharani_bakery_app/models/cakeCategory.dart';
// import 'package:maharani_bakery_app/models/category.dart';
// import 'package:maharani_bakery_app/screens/cakeCategoryScreen.dart';
// import 'package:maharani_bakery_app/screens/categoryScreen.dart';
// import 'package:optimized_cached_image/optimized_cached_image.dart';
//
// class Categories extends StatelessWidget {
//   Categories({Key? key}) : super(key: key);
//
//
//   Widget _buildCakeCategories(BuildContext context) {
//     List<Widget> nearbyResturatsList = [];
//     cakeCategories.forEach((CakeCategory category) {
//       nearbyResturatsList.add(
//           GestureDetector(
//             onTap: () {
//               // Navigator.push(
//               //     context,
//               //     MaterialPageRoute(builder: (_) => CakeCategoryScreen(category: category)));
//             },
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15.0),
//                 border: Border.all(
//                   width: 1.0,
//                   color: Colors.black12,
//                 ),
//               ),
//               child: Row(
//                 //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(15.0),
//                     child: Container(
//                       child: CachedNetworkImage(
//                         imageUrl: "https://res.cloudinary.com/maharani/image/upload/${category.imageUrl}/image_asset/${category.firebaseId}.jpg",
//                         width: 150,
//                         height: 150,
//                         fit: BoxFit.cover,
//                         errorWidget: (context, url, error) => Icon(Icons.error),
//                       ),
//                       // Image(
//                       //   image: OptimizedCacheImageProvider("https://res.cloudinary.com/maharani/image/upload/${category.imageUrl}/image_asset/${category.firebaseId}.jpg"),
//                       //   width: 150,
//                       //   height: 150,
//                       //   fit: BoxFit.cover,
//                       // ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       margin: EdgeInsets.symmetric(horizontal: 12.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             category.name,
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: "Candarai"
//                             ),
//                             overflow: TextOverflow.visible,
//                           ),
//                           SizedBox(height: 10.0),
//                           Text(
//                             category.description,
//                             style: TextStyle(
//                                 fontSize: 12,
//                                 fontFamily: "Candarai"
//                             ),
//                             overflow: TextOverflow.visible,
//                           ),
//                           SizedBox(
//                             height: 4.0,
//                           ),
//                           SizedBox(
//                             height: 4.0,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ));
//     });
//
//     return Column(
//       children: nearbyResturatsList,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildCakeCategories(context)
//       ],
//     );
//   }
// }
