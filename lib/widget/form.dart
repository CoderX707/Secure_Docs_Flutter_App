import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secure_docs/controller/doc_controller.dart';
import 'package:secure_docs/model/doc_model.dart';

enum ImageSourceType { gallery, camera }

// Create a Form widget.
class CustomForm extends StatefulWidget {
  CustomForm({super.key, this.doc});
  Doc? doc;
  @override
  CustomFormState createState() {
    return CustomFormState();
  }
}

class CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormState>();
  final DocController _docsController = Get.find();

  File? _image;
  var imagePicker;
  dynamic base64Image;
  late String title;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.doc != null) {
      Uint8List imageString =
          const Base64Decoder().convert(widget.doc!.filebase64);
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              initialValue: widget.doc!.title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                title = value;
                return null;
              },
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  XFile image = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 100,
                      preferredCameraDevice: CameraDevice.front);
                  setState(() {
                    _image = File(image.path);
                  });
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(color: Colors.red[200]),
                  child: _image != null
                      ? Image.file(
                          _image!,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fitHeight,
                        )
                      : Image.memory(
                          imageString,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_image != null) {
                      final bytes = File(_image!.path).readAsBytesSync();
                      base64Image = base64Encode(bytes);
                    } else {
                      base64Image = widget.doc!.filebase64;
                    }
                    final document = Doc(
                      id: widget.doc!.id,
                      title: title,
                      filebase64: base64Image,
                      createdTime: DateTime.now(),
                    );
                    _docsController.updateDoc(document);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Document Updated')),
                    );
                    Get.back();
                  }
                },
                child: const Text('Update Document'),
              ),
            ),
          ],
        ),
      );
    } else {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                title = value;
                return null;
              },
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  XFile image = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 100,
                      preferredCameraDevice: CameraDevice.front);
                  setState(() {
                    _image = File(image.path);
                  });
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(color: Colors.red[200]),
                  child: _image != null
                      ? Image.file(
                          _image!,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fitHeight,
                        )
                      : Container(
                          decoration: BoxDecoration(color: Colors.red[200]),
                          width: 200,
                          height: 200,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _image != null) {
                    final bytes = File(_image!.path).readAsBytesSync();
                    base64Image = base64Encode(bytes);
                    final document = Doc(
                      title: title,
                      filebase64: base64Image,
                      createdTime: DateTime.now(),
                    );
                    _docsController.insertDoc(document);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Document Saved')),
                    );
                    Get.back();
                  }
                },
                child: const Text('Save Document'),
              ),
            ),
          ],
        ),
      );
    }
  }
}
