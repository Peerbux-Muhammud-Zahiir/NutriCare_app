import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class CameraStream extends StatefulWidget {
  const CameraStream({super.key});

  @override
  State<CameraStream> createState() => _CameraStreamState();
}

class _CameraStreamState extends State<CameraStream> {
  CameraController? _cameraController;
  tfl.Interpreter? _interpreter;
  bool _isDetecting = false;
  String _predictedLabel = '';
  dynamic _confidence = 0;
  List<String> labels = [];
  Timer? _timer;
  bool _isCameraMode = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadLabels();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter?.close();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final firstCamera = cameras.first;
        _cameraController = CameraController(
          firstCamera,
          ResolutionPreset.high,
        );
        await _cameraController?.initialize();
        if (!mounted) return;

        // Start a timer to capture an image every 5 seconds
        _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
          if (!_isDetecting) {
            _isDetecting = true;
            final image = await _cameraController?.takePicture();
            if (image != null) {
              final bytes = await image.readAsBytes();
              _runModelOnImage(bytes);
            }
          }
        });

        setState(() {});
      } else {
        print('No cameras available');
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await tfl.Interpreter.fromAsset('assets/foodpretrainedmodel.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> _loadLabels() async {
    try {
      final csvData = await rootBundle.loadString('assets/foodpretrainedmodel.csv');
      final lines = csvData.split('\n');
      labels = [];
      for (var i = 1; i < lines.length; i++) { // Skip the first line (header)
        final parts = lines[i].split(',');
        if (parts.length > 1) {
          labels.add(parts[1].trim());
        }
      }
      print('Labels loaded: $labels');
    } catch (e) {
      print('Error loading labels: $e');
    }
  }

  Future<void> _runModelOnFrame(CameraImage image) async {
    try {
      final input = _preprocessCameraImage(image);
      print('Input tensor: $input');

      // Define output tensor with shape [1, 2024] and type float32
      final output = List.filled(1 * 2024, 0.0).reshape([1, 2024]);

      print('Running model...');
      _interpreter?.run(input, output);
      print('Model run complete');

      print('Output tensor: $output');

      // Convert output tensor to a list of doubles
      final outputList = output[0].map((e) => e.toDouble()).toList();

      // Ensure the reduce function uses the correct type
      final predictedIndex = outputList.indexWhere((element) => element == outputList.reduce((a, b) => a > b ? a : b));
      setState(() {
        _predictedLabel = labels[predictedIndex];
        _confidence = outputList[predictedIndex];
      });
    } catch (e) {
      print('Error running model on frame: $e');
    } finally {
      _isDetecting = false;
    }
  }

  Future<void> _runModelOnImage(Uint8List imageBytes) async {
    try {
      final input = _preprocessMemoryImage(imageBytes);
      print('Input tensor: $input');

      // Define output tensor with shape [1, 2024] and type float32
      final output = List.filled(1 * 2024, 0.0).reshape([1, 2024]);

      print('Running model...');
      _interpreter?.run(input, output);
      print('Model run complete');

      print('Output tensor: $output');

      // Convert output tensor to a list of doubles
      final outputList = output[0].map((e) => e.toDouble()).toList();

      // Ensure the reduce function uses the correct type
      final predictedIndex = outputList.indexWhere((element) => element == outputList.reduce((a, b) => a > b ? a : b));
      setState(() {
        _predictedLabel = labels[predictedIndex];
        _confidence = outputList[predictedIndex];
      });
    } catch (e) {
      print('Error running model on image: $e');
    } finally {
      _isDetecting = false;
    }
  }

  List<List<List<List<int>>>> _preprocessCameraImage(CameraImage image) {
    final img.Image convertedImage = _convertCameraImage(image);
    final resizedImage = img.copyResize(convertedImage, width: 224, height: 224);
    final input = List.generate(1, (i) => List.generate(224, (j) => List.generate(224, (k) => List.generate(3, (l) => 0))));
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resizedImage.getPixel(x, y);
        input[0][y][x][0] = img.getRed(pixel);
        input[0][y][x][1] = img.getGreen(pixel);
        input[0][y][x][2] = img.getBlue(pixel);
      }
    }
    return input;
  }

  List<List<List<List<int>>>> _preprocessMemoryImage(Uint8List imageBytes) {
    final img.Image convertedImage = img.decodeImage(imageBytes)!;
    final resizedImage = img.copyResize(convertedImage, width: 224, height: 224);
    final input = List.generate(1, (i) => List.generate(224, (j) => List.generate(224, (k) => List.generate(3, (l) => 0))));
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resizedImage.getPixel(x, y);
        input[0][y][x][0] = img.getRed(pixel);
        input[0][y][x][1] = img.getGreen(pixel);
        input[0][y][x][2] = img.getBlue(pixel);
      }
    }
    return input;
  }

  img.Image _convertCameraImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final img.Image imgImage = img.Image(width, height);

    for (int planeIndex = 0; planeIndex < image.planes.length; planeIndex++) {
      final plane = image.planes[planeIndex];
      final bytes = plane.bytes;
      final rowStride = plane.bytesPerRow;
      final pixelStride = plane.bytesPerPixel ?? 1;

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final byteIndex = y * rowStride + x * pixelStride;
          if (byteIndex < bytes.length) {
            final pixelValue = bytes[byteIndex];
            imgImage.setPixel(x, y, img.getColor(pixelValue, pixelValue, pixelValue));
          }
        }
      }
    }

    return imgImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Object Detection'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isCameraMode = !_isCameraMode;
                if (_isCameraMode) {
                  _initializeCamera();
                } else {
                  _cameraController?.dispose();
                  _cameraController = null;
                }
              });
            },
            child: Text(_isCameraMode ? 'Stop Camera Stream' : 'Start Camera Stream'),
          ),
          Expanded(
            child: _cameraController != null && _cameraController!.value.isInitialized
                ? CameraPreview(_cameraController!)
                : Center(child: CircularProgressIndicator()),
          ),
          Text(
            'Predicted Label: $_predictedLabel (Confidence: $_confidence)',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}