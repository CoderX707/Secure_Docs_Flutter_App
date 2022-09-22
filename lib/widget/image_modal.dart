import 'package:flutter/material.dart';

class ImageModal extends StatelessWidget {
  const ImageModal({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Wrap(
        children: [
          Text('Document Title'),
          Image.network(
            url,
            fit: BoxFit.fitWidth,
          ),
          Text('Document Title'),
        ],
      ),
    );
    ;
  }
}
