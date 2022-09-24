import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:secure_docs/db/db.dart';
import 'package:secure_docs/helper/menu_helper.dart';
import 'package:secure_docs/model/doc_model.dart';
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
  late List<Doc> docs;
  late bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    getDocumentsFromDB();
  }

  void getDocumentsFromDB() async {
    docs = await DocsDatabase.instance.readAllDocs();
    setState(() {
      isLoading = false;
    });
  }

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
        body: Column(
          children: [
            isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : docs.isEmpty
                    ? const Expanded(
                        child: Center(child: Text("No document found")))
                    : Expanded(
                        child: StaggeredGridView.countBuilder(
                          crossAxisCount: 2,
                          itemCount: docs.length,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          itemBuilder: (context, index) {
                            Uint8List imageString = const Base64Decoder()
                                .convert(docs[index].filebase64);
                            return GestureDetector(
                              onTap: () {
                                // print('called');
                                /* single view */
                              },
                              onLongPress: () async {
                                setState(() {
                                  longPressPreview = true;
                                });
                                _animationController.forward();
                                _popupDialog = _createPopupDialog(docs[index]);
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
                                    Text(docs[index].title),
                                  ],
                                ),
                              ),
                            );
                          },
                          staggeredTileBuilder: (index) =>
                              const StaggeredTile.fit(1),
                        ),
                      ),
          ],
        ),
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
