import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyGalleryApp extends StatefulWidget {
  const MyGalleryApp({super.key});

  @override
  State<MyGalleryApp> createState() => _MyGalleryAppState();
}

class _MyGalleryAppState extends State<MyGalleryApp> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? images;
  int currentPage = 0;

  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    images = await _picker.pickMultiImage();

    if (images != null) {
      Timer.periodic(Duration(seconds: 4), (timer) {
        currentPage++;

        if (currentPage > images!.length - 1) {
          currentPage = 0;
        }
        pageController.animateToPage(currentPage, duration: Duration(milliseconds: 3), curve: Curves.easeIn);
      });
    }

    //화면갱신
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('전자액자'),
      ),
      body: images == null
          ? Center(child: Text('No data'))
          : PageView(
                  controller: pageController,
              children: images!.map((image) {
                return FutureBuilder<Uint8List>(
                    future: image.readAsBytes(),
                    builder: (context, snapshot) {
                      final data = snapshot.data;

                      if (data == null ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Image.memory(
                        data,
                        width: double.infinity,
                      );
                    });
              }).toList(),
            ),
    );
  }
}
