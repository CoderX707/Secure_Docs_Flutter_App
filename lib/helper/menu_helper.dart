import 'package:flutter/material.dart';
import 'package:secure_docs/pages/create_page.dart';

void handleClick(int item, context) {
  switch (item) {
    case 0:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreatePage()),
      );
      break;
    case 1:
      break;
  }
}
