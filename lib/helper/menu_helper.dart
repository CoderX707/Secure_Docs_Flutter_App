import 'package:get/get.dart';

import 'package:secure_docs/pages/create_page.dart';

void handleClick(int item, context) {
  switch (item) {
    case 0:
     Get.to(const CreatePage());
      break;
    case 1:
      break;
  }
}
