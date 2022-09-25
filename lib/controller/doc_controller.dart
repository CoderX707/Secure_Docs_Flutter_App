import 'package:get/get.dart';
import 'package:secure_docs/db/db.dart';
import 'package:secure_docs/model/doc_model.dart';

class DocController extends GetxController {
  var documentsList = <Doc>[].obs;
  var num = 0.obs;

  @override
  void onInit() async {
    await getAllDocs();
    super.onInit();
  }

  Future<void> getAllDocs() async {
    documentsList.clear();
    DocsDatabase.instance.readAllDocs().then((value) => {
          value.forEach((element) {
            documentsList.add(Doc(
                id: element.id,
                title: element.title,
                filebase64: element.filebase64,
                createdTime: element.createdTime));
          })
        });
  }

  Future<void> insertDoc(Doc doc) async {
    await DocsDatabase.instance.create(doc);
    documentsList.add(doc);
    getAllDocs();
  }

  Future<void> deleteDoc(int? id) async {
    await DocsDatabase.instance.delete(id!);
    getAllDocs();
  }

  Future<void> updateDoc(Doc doc) async {
    await DocsDatabase.instance.update(doc);
    getAllDocs();
  }
}
