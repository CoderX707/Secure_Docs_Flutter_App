import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:secure_docs/helper/menu_helper.dart';
import 'package:secure_docs/widget/image_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<String> images = [
    "https://uae.microless.com/cdn/no_image.jpg",
    "https://images-na.ssl-images-amazon.com/images/I/81aF3Ob-2KL._UX679_.jpg",
    "https://www.boostmobile.com/content/dam/boostmobile/en/products/phones/apple/iphone-7/silver/device-front.png.transform/pdpCarousel/image.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgUgs8_kmuhScsx-J01d8fA1mhlCR5-1jyvMYxqCB8h3LCqcgl9Q",
    "https://ae01.alicdn.com/kf/HTB11tA5aiAKL1JjSZFoq6ygCFXaw/Unlocked-Samsung-GALAXY-S2-I9100-Mobile-Phone-Android-Wi-Fi-GPS-8-0MP-camera-Core-4.jpg_640x640.jpg",
    "https://media.ed.edmunds-media.com/gmc/sierra-3500hd/2018/td/2018_gmc_sierra-3500hd_f34_td_411183_1600.jpg",
    "https://hips.hearstapps.com/amv-prod-cad-assets.s3.amazonaws.com/images/16q1/665019/2016-chevrolet-silverado-2500hd-high-country-diesel-test-review-car-and-driver-photo-665520-s-original.jpg",
    "https://www.galeanasvandykedodge.net/assets/stock/ColorMatched_01/White/640/cc_2018DOV170002_01_640/cc_2018DOV170002_01_640_PSC.jpg",
    "https://media.onthemarket.com/properties/6191869/797156548/composite.jpg",
    "https://media.onthemarket.com/properties/6191840/797152761/composite.jpg",
  ];
  late OverlayEntry _popupDialog;
  late AnimationController _animationController;
  late bool longPressPreview = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
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
            Expanded(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                itemCount: images.length,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                itemBuilder: (context, index) {
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
                      _popupDialog = _createPopupDialog(images[index]);
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
                          Image.network(images[index]),
                          const Text("Document Title"),
                        ],
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
              ),
            ),
          ],
        ),
      ),
    );
  }

// create Overlay
  OverlayEntry _createPopupDialog(String url) {
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
            child: ImageModal(url: url),
          ),
        ),
      ),
    );
  }
}
