import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CaptureProfilePicScreen extends StatefulWidget {
  static const routeName = "/capture-profile-pic-screen";
  const CaptureProfilePicScreen({super.key});

  @override
  State<CaptureProfilePicScreen> createState() => _CaptureProfilePicScreenState();
}

class _CaptureProfilePicScreenState extends State<CaptureProfilePicScreen> {
  late CameraController _cameraController;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(_cameras![0], ResolutionPreset.high);
      await _cameraController.initialize();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameras == null || _cameras!.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No cameras found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.white,
          child: const Text("@userName"),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: _cameraController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _cameraController.value.aspectRatio,
                      child: Transform.scale(
                        scaleX: 0.8,
                        scaleY: 0.6,
                        child: CameraPreview(_cameraController),
                      ),
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
            ),
            Positioned.fill(
              child: Container(
                // Add your frame styling here
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Implement filter functionality here
                      },
                      icon: Icon(Icons.filter),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Implement capture functionality here
                      },
                      child: Icon(Icons.camera),
                    ),
                    IconButton(
                      onPressed: () {
                        // Implement upload image functionality here
                      },
                      icon: Icon(Icons.upload),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
