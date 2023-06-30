import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
class CompressedImage extends StatefulWidget {
  final String imageUrl;
  final int quality;

  CompressedImage({required this.imageUrl, required this.quality});

  @override
  _CompressedImageState createState() => _CompressedImageState();
}

class _CompressedImageState extends State<CompressedImage> {
  late Uint8List _compressedImage = Uint8List(1);
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _compressImage();
  }

  Future<void> _compressImage() async {
    setState(() {
      loaded = false;
    });
    final response = await http.get(Uri.parse(widget.imageUrl));
    var imageData = response.bodyBytes;
    final compressedImageData = await FlutterImageCompress.compressWithList(imageData, quality: widget.quality);
    // while(true) {
    if (mounted) {
      setState(() {
        _compressedImage = compressedImageData;
        loaded = true;
      });
      // break;
      // }
    }

  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? Image.memory(_compressedImage, fit: BoxFit.cover)
        : Row(
      children: [
        Spacer(),
        Image.asset("assets/images/load.gif", height: 80, width: 80,),
        Spacer(),
      ],
    );
  }
}
