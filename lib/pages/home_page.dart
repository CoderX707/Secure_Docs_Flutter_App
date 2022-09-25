import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'package:secure_docs/controller/doc_controller.dart';
import 'package:secure_docs/helper/menu_helper.dart';
import 'package:secure_docs/model/doc_model.dart';
import 'package:secure_docs/pages/view_doc_page.dart';
import 'package:secure_docs/widget/image_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late OverlayEntry _popupDialog;
  late AnimationController _animationController;
  late bool longPressPreview = false;
  late bool isLoading = true;
  final DocController _docsController = Get.put(DocController());

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    // getDocumentsFromDB();
  }

  // void getDocumentsFromDB() async {
  //   await _docsController.getAllDocs();
  //   print(_docsController.documentsList.length);
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Secure Docs'),
          actions: [
            PopupMenuButton<int>(
              onSelected: (item) => handleClick(item, context),
              itemBuilder: (context) => const [
                PopupMenuItem<int>(value: 0, child: Text('New Doc')),
                PopupMenuItem<int>(value: 1, child: Text('Exit')),
              ],
            ),
          ],
        ),
        body: Obx(() {
          if (_docsController.documentsList.isEmpty) {
            return const Center(
              child: Text("No Documents Found"),
            );
          } else if (_docsController.documentsList.isNotEmpty) {
            return StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemCount: _docsController.documentsList.length,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
              itemBuilder: (context, index) {
                Uint8List imageString = const Base64Decoder()
                    .convert(_docsController.documentsList[index].filebase64);
                return GestureDetector(
                  onTap: () {
                    Get.to(ViewDocument(
                        doc: _docsController.documentsList[index]));
                  },
                  onLongPress: () async {
                    setState(() {
                      longPressPreview = true;
                    });
                    _animationController.forward();
                    _popupDialog = _createPopupDialog(
                        _docsController.documentsList[index]);
                    Overlay.of(context)!.insert(_popupDialog);
                  },
                  onLongPressEnd: (details) {
                    _animationController.reverse();
                    setState(() {
                      longPressPreview = false;
                    });
                    _popupDialog.remove();
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Image.memory(
                          imageString,
                          gaplessPlayback: true,
                        ),
                        Text(_docsController.documentsList[index].title),
                      ],
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }

// create Overlay
  OverlayEntry _createPopupDialog(Doc doc) {
    return OverlayEntry(
      builder: (context) => Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.11,
        color: Colors.black.withOpacity(0.6),
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.5, curve: Curves.ease),
          ),
          child: Dialog(
            child: ImageModal(document: doc),
          ),
        ),
      ),
    );
  }
}
