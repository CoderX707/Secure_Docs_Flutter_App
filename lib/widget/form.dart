import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secure_docs/db/db.dart';
import 'package:secure_docs/model/doc_model.dart';

enum ImageSourceType { gallery, camera }

// Create a Form widget.
class CustomForm extends StatefulWidget {
  const CustomForm({super.key});

  @override
  CustomFormState createState() {
    return CustomFormState();
  }
}

class CustomFormState extends State<CustomForm> {
  final _formKey = GlobalKey<FormState>();
  var _image;
  var _title;
  var imagePicker;
  var base64Image;
late List<Doc> notes;
  @override
  void initState() async{
    super.initState();
    imagePicker = ImagePicker();
    this.notes = await DocsDatabase.instance.readAllDocs();
    print(this.notes[0].title);
    print(this.notes[0].createdTime);
    print(this.notes[0].filebase64);
  }

  @override
  Widget build(BuildContext context) {
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
              _title = value;
            },
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                XFile image = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
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
                        _image,
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
                  base64Image = "data:image/png;base64," + base64Encode(bytes);
                  await addNote();
                  // Navigator.of(context).pop();
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Processing Data')),
                  // );
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  void addOrUpdateNote() async {
    await addNote();
    Navigator.of(context).pop();
  }

  // Future updateNote() async {
  //   final note = widget.note!.copy(
  //     isImportant: isImportant,
  //     number: number,
  //     title: title,
  //     description: description,
  //   );

  //   await NotesDatabase.instance.update(note);
  // }

  Future addNote() async {
    final note = Doc(
      title: _title,
      filebase64: base64Image,
      createdTime: DateTime.now(),
    );

    await DocsDatabase.instance.create(note);
  }
}
