import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadImages extends StatefulWidget {
  const UploadImages({Key? key}) : super(key: key);

  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  Uint8List? imageBytes;
  String? url;
  String fileName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: pickImage,
                child: const Icon(
                  Icons.person,
                  size: 200,
                )),
            url!.isNotEmpty
                ? Text(url.toString())
                : const Text("Url of the image"),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Selected Image: $fileName',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            if (url != null)
              Image.network(
                url!,
                width: 200,
                height: 200,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      final fileBytes = result.files.single.bytes;
      final file = result.files.single;
      setState(() {
        imageBytes = fileBytes;
        //fileName = file.name;
        url = 'data:image/jpeg;base64,${base64Encode(imageBytes!)}';
      });
      //logger.i(fileName.toString());
      //logger.i(url);
    }
  }
}
