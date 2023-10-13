import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:typed_data';

class FaceDetectionWidget extends StatefulWidget {
  @override
  _FaceDetectionWidgetState createState() => _FaceDetectionWidgetState();
}

class _FaceDetectionWidgetState extends State<FaceDetectionWidget> {
  late CameraController _cameraController;
  bool isDetecting = false;
  late FaceDetector _faceDetector;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeFaceDetector();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(firstCamera, ResolutionPreset.high);
    await _cameraController.initialize();
    _cameraController.startImageStream((CameraImage image) {
      if (isDetecting) return;
      _detectFaces(image);
    });
  }

  void _initializeFaceDetector() {
    _faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
      mode: FaceDetectorMode.accurate,
      enableClassification: false,
      enableLandmarks: true,
      enableTracking: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Face Detection Example'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: CameraPreview(_cameraController),
          ),
          ElevatedButton(
            onPressed: isDetecting ? null : _toggleDetecting,
            child: Text(isDetecting ? 'Detecting...' : 'Detect Faces'),
          ),
        ],
      ),
    );
  }

  void _detectFaces(CameraImage image) async {
    if (!mounted) return;

    setState(() {
      isDetecting = true;
    });

    try {
      final metadata = FirebaseVisionImageMetadata(
        rawFormat: image.format.raw,
        size: Size(image.width.toDouble(), image.height.toDouble()),
        planeData: image.planes.map((plane) {
          return FirebaseVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        }).toList(),
      );

      final uint8List = Uint8List.fromList(image.planes[0].bytes);
      final visionImage = FirebaseVisionImage.fromBytes(uint8List, metadata);

      final faces = await _faceDetector.processImage(visionImage);

      for (var face in faces) {
        print('Face ID: ${face.trackingId}');
        print(
            'Face Landmarks: ${face.getLandmark(FaceLandmarkType.values as FaceLandmarkType)}');
      }
    } catch (e) {
      print('Error during face detection: $e');
    } finally {
      setState(() {
        isDetecting = false;
      });
    }
  }

  void _toggleDetecting() {
    setState(() {
      isDetecting = !isDetecting;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _faceDetector.close();
    super.dispose();
  }
}
