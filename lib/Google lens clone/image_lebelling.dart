import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageLabelling extends StatefulWidget {
  const ImageLabelling({super.key});

  @override
  State<ImageLabelling> createState() => _ImageLabellingState();
}

class _ImageLabellingState extends State<ImageLabelling> {
  bool imageLabelling = false;
  XFile? targetImage;
  String searchText = "";

  Future<void> _getImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        imageLabelling = true;
        targetImage = pickedImage;
        setState(() {});
        getImageLabels(pickedImage);
        imageLabelling = false;
      }
    } catch (e) {
      imageLabelling = false;
      targetImage = null;
      setState(() {});
    }
  }

  Future<void> _captureImage() async {
    try {
      final capturedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (capturedImage != null) {
        imageLabelling = true;
        targetImage = capturedImage;
        setState(() {});
        getImageLabels(capturedImage);
        imageLabelling = false;
      }
    } catch (e) {
      imageLabelling = false;
      targetImage = null;
      setState(() {});
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: searchText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Text copied to clipboard'),
      ),
    );
  }

  void getImageLabels(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    ImageLabeler imageLabeler = ImageLabeler(options: ImageLabelerOptions());
    List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    StringBuffer sb = StringBuffer();

    for (ImageLabel imgLabel in labels) {
      String lblText = imgLabel.label;
      //double confidence = imgLabel.confidence;
      sb.write(lblText);
      sb.write(" ");
    }
    imageLabeler.close();
    searchText = sb.toString();
    imageLabelling = false;
    if (kDebugMode) {
      print(searchText);
    }
    _performGoogleSearch();
    setState(() {});
  }

  late Uri searchResultsUrl;
  bool searchResultsVisible = false;

  Future<void> _performGoogleSearch() async {
    final searchQuery = searchText;

    final encodedQuery = Uri.encodeComponent(searchQuery);

    // Construct the Google search URL
    final url = 'https://www.google.com/search?q=$encodedQuery';
    searchResultsUrl = Uri.parse(url);
    if (kDebugMode) {
      print(searchResultsUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (!imageLabelling && targetImage == null)
        Container(
          width: 300,
          height: 300,
          color: Colors.grey[300]!,
          child: const Center(
            child: Text(
              "No Image",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        )
      else if (imageLabelling)
        const CircularProgressIndicator()
      else if (targetImage != null)
        Expanded(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Image.file(File(targetImage!.path))),
        ), // Show the selected image when it's not null
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: _getImage,
            tooltip: 'Pick Image from Gallery',
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _captureImage,
            tooltip: 'Capture Image from Camera',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              launchUrl(searchResultsUrl, mode: LaunchMode.inAppWebView);
            },
            tooltip: 'Capture Image from Camera',
          ),
        ],
      ),
      const SizedBox(height: 20),
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onLongPress: _copyToClipboard,
            child: Text(
              searchText,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    ]);
  }
}
