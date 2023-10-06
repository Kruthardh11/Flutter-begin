import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _selectedImage;
  Future<void> getImageGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // The user picked an image.
      // You can use pickedFile.path to get the file path of the selected image.
      // For example, to display the selected image, you can use an Image widget:
      // You can also upload or process the image here.

      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      print("BAlls");
    }
  }

  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // The user captured a new image.
      // You can use pickedFile.path to get the file path of the captured image.
      // For example, to display the captured image, you can use an Image widget:
      // You can also upload or process the imagse here.
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      print(_selectedImage);
    } else {
      // The user canceled capturing an image.
      print("BAlls");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: getImageGallery,
            tooltip: 'Pick Image from Gallery',
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _captureImage,
            tooltip: 'Capture Image from Camera',
          ),
        ],
      ),
      Container(
        margin: const EdgeInsets.all(16.0),
        child: _selectedImage != null
            ? Image.file(
                _selectedImage!,
                height: 350,
                width: 350,
              )
            // Display the selected image
            : const Text('No image selected'),
      ),
    ]);
  }
}
