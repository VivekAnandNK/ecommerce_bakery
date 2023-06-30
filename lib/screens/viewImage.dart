import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatefulWidget {
  final String imageUrl, firebaseId;
  final String type;
  final dynamic item;
  const ViewImage({Key? key, required this.imageUrl, required this.firebaseId, required this.type, required this.item}) : super(key: key);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          Container(
              child: widget.type == "cake" ?  ImageSlideshow(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                initialPage: 0,
                indicatorColor: Colors.black,
                indicatorBackgroundColor: Colors.white,
                children: [

                  for(var elements=0; elements<widget.item.imageUrl.length; elements++)
                    PhotoView(
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2.0,
                      imageProvider: widget.item.imageUrl[elements].contains("res.cloudinary.com") ? OptimizedCacheImageProvider(widget.item.imageUrl[elements]) : OptimizedCacheImageProvider("https://res.cloudinary.com/maharani/image/upload/${widget.imageUrl}/image_asset/${widget.firebaseId}.jpg"),
                    ),
                ],
                onPageChanged: (value) {
                  // print('Page changed: $value');
                },
              ) : PhotoView(
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.0,
                imageProvider: widget.imageUrl.contains("res.cloudinary.com") ? OptimizedCacheImageProvider(widget.imageUrl) : OptimizedCacheImageProvider("https://res.cloudinary.com/maharani/image/upload/${widget.imageUrl}/image_asset/${widget.firebaseId}.jpg"),
              )
          ),
        ],
      ),
    );
  }
}
