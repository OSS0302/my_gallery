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

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    images = await _picker.pickMultiImage();

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
          : FutureBuilder<Uint8List>(
              future: images![0].readAsBytes(),
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
              }),
    );
  }
}
