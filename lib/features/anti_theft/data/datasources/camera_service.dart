import 'package:camera/camera.dart';

class CameraService {
  List<CameraDescription>? _cameras;
  CameraController? _controller;

  Future<void> initialize() async {
    _cameras = await availableCameras();
    final frontCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras!.first,
    );
    _controller = CameraController(frontCamera, ResolutionPreset.medium);
    await _controller!.initialize();
  }

  Future<String?> capturePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return null;
    final image = await _controller!.takePicture();
    return image.path;
  }

  void dispose() {
    _controller?.dispose();
  }
}