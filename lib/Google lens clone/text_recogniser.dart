import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class TextRecogniser extends StatefulWidget {
  const TextRecogniser({super.key});

  @override
  State<TextRecogniser> createState() => _TextRecogniserState();
}

class _TextRecogniserState extends State<TextRecogniser> {
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";

  Future<void> _getImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        _getRecognisedText(pickedImage);
        textScanning = false;
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      setState(() {});
    }
  }

  Future<void> _captureImage() async {
    try {
      final capturedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (capturedImage != null) {
        textScanning = true;
        imageFile = capturedImage;
        setState(() {});
        _getRecognisedText(capturedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      setState(() {});
    }
  }

  Future<void> _getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    setState(() {});
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: scannedText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Text copied to clipboard'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (!textScanning &&
          imageFile ==
              null) // Show gray area when textScanning is false and no image selected
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
      else if (textScanning)
        const CircularProgressIndicator()
      else if (imageFile != null)
        Expanded(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Image.file(File(imageFile!.path))),
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
        ],
      ),
      SizedBox(height: 20),
      Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: GestureDetector(
            onLongPress: _copyToClipboard,
            child: Text(
              scannedText,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    ]);
  }
}
