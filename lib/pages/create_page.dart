import 'package:flutter/material.dart';

import 'package:secure_docs/model/doc_model.dart';
import 'package:secure_docs/widget/form.dart';

class CreatePage extends StatefulWidget {
  CreatePage({super.key, this.document});
Doc? document;
  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(widget.document != null ? 'Update Document' : 'Add Document'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CustomForm(
          doc: widget.document,
        ),
      ),
    ));
  }
}
