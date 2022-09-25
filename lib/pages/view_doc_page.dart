import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:secure_docs/controller/doc_controller.dart';
import 'package:secure_docs/db/db.dart';

import 'package:secure_docs/model/doc_model.dart';
import 'package:secure_docs/pages/create_page.dart';

class ViewDocument extends StatelessWidget {
  ViewDocument({super.key, required this.doc});
  final DocController _docsController = Get.find();
  Doc doc;
  @override
  Widget build(BuildContext context) {
    Uint8List imageString = const Base64Decoder().convert(doc.filebase64);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(doc.title),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.memory(
              imageString,
              gaplessPlayback: true,
              fit: BoxFit.fill,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.green),
                  ),
                  onPressed: () => (Get.to(CreatePage(document: doc))),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                ElevatedButton.icon(
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.red),
                  ),
                  onPressed: () {
                    _docsController.deleteDoc(doc.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Document Deleted')),
                    );
                    Get.back();
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
