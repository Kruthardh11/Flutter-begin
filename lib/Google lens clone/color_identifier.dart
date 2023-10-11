import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ColorIdentifier extends StatefulWidget {
  const ColorIdentifier({super.key});

  @override
  State<ColorIdentifier> createState() => _ColorIdentifierState();
}

class _ColorIdentifierState extends State<ColorIdentifier> {
  bool _hasRunmodel = false;
  File? _image;
  List? _result;
  final _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _hasRunmodel
            ? Column(
                children: [
                  SizedBox(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: Image.file(_image!)),
                  Container(
                    child: Text('${_result![0]['label']}'),
                  )
                ],
              )
            : const Text('COlor Detection'),
      ],
    );
  }
}
