import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognitionAndTranslationWidget extends StatefulWidget {
  // Add a named key parameter to the constructor
  const TextRecognitionAndTranslationWidget({Key? key}) : super(key: key);

  @override
  _TextRecognitionAndTranslationWidgetState createState() =>
      _TextRecognitionAndTranslationWidgetState();
}

class _TextRecognitionAndTranslationWidgetState
    extends State<TextRecognitionAndTranslationWidget> {
  String? recognizedText;
  String? translatedText;

  @override
  void initState() {
    super.initState();
    // Initialize the camera
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String?> captureImageAndTranslate() async {
    try {
      final imagePicker = ImagePicker();
      final XFile? imageFile =
          await imagePicker.pickImage(source: ImageSource.camera);

      if (imageFile == null) {
        // No image selected
        return null;
      }

      final inputImage = InputImage.fromFile(File(imageFile.path));
      final recognizedText = await recognizeText(inputImage);

      if (recognizedText == null || recognizedText.isEmpty) {
        // No text recognized
        return null;
      }

      final translatedText = await translateText(recognizedText);
      print("printed text sucker \n$translatedText");
      return translatedText;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<String?> recognizeText(InputImage inputImage) async {
    try {
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);
      textRecognizer.close();

      setState(() {
        this.recognizedText = recognizedText.text;
      });
      print("Recognized text:\n$recognizedText");
      return recognizedText.text;
    } catch (e) {
      // Handle any exceptions if needed
      print("Error recognizing text: $e");
      return null;
    }
  }

  Future<String?> translateText(String recognizedText) async {
    try {
      final langIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
      final languageCode =
          await langIdentifier.identifyLanguage(recognizedText);
      langIdentifier.close();
      final translator = OnDeviceTranslator(
          sourceLanguage: TranslateLanguage.values
              .firstWhere((element) => element.bcpCode == languageCode),
          targetLanguage: TranslateLanguage.english);
      final translatedText = await translator.translateText(recognizedText);

      // Update the state variable with the translated text
      setState(() {
        this.translatedText = translatedText;
      });
      print("translated text $translatedText");

      return translatedText;
    } catch (e) {
      print('error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Recognized Text:',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, // Use vertical scrolling
                child: Text(
                  recognizedText ?? 'No text recognized yet.',
                  style: TextStyle(fontSize: 20), // Increase font size
                ),
              ),
            ),
          ),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Translated Text:',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Use vertical scrolling
                child: Text(
                  translatedText ?? 'No text recognized yet.',
                  style: TextStyle(fontSize: 20), // Increase font size
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: captureImageAndTranslate,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
