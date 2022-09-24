import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:secure_docs/model/doc_model.dart';

class ImageModal extends StatelessWidget {
  ImageModal({super.key, required this.document});
  Doc document;
  @override
  Widget build(BuildContext context) {
    Uint8List imageString = const Base64Decoder().convert(document.filebase64);
    return ClipRRect(
      child: Wrap(
        children: [
          Text(document.title),
          Image.memory(
            imageString,
            fit: BoxFit.fitWidth,
            gaplessPlayback: true,
          ),
          Text("${document.createdTime}"),
        ],
      ),
    );
  }
}
