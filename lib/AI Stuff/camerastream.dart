import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class CameraStream extends StatefulWidget {
  final Function(String, String, Uint8List) onFoodDetected;

  const CameraStream({super.key, required this.onFoodDetected});

  @override
  State<CameraStream> createState() => _CameraStreamState();
}

class _CameraStreamState extends State<CameraStream> {
  Map<String, String> labelCaloriesMap = {};
  CameraController? _cameraController;
  tfl.Interpreter? _interpreter;
  bool _isDetecting = false;
  String _predictedLabel = '';
  dynamic _confidence = 0;
  List<String> labels = [];
  Timer? _timer;
  bool _isCameraMode = false;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _loadLabels();
    _initializeCamera();
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

        _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
          if (!_isDetecting) {
            _isDetecting = true;
            final image = await _cameraController?.takePicture();
            if (image != null) {
              final bytes = await image.readAsBytes();
              _imageBytes = bytes;
              _runModelOnImage(bytes);
            }
            _isDetecting = false;
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
      final csvData = await rootBundle.loadString('assets/foodpretrainedmodel2.csv');
      final lines = csvData.split('\n');
      labels = [];
      labelCaloriesMap = {};
      for (var i = 1; i < lines.length; i++) {
        final parts = lines[i].split(',');
        if (parts.length > 2) {
          final id = parts[0].trim();
          final name = parts[1].trim();
          final calories = parts[2].trim();
          labels.add(name);
          labelCaloriesMap[name] = calories;
        }
      }
      print('Names and calories loaded');
    } catch (e) {
      print('Error loading names and calories: $e');
    }
  }

  Future<void> _runModelOnFrame(CameraImage image) async {
    try {
      final input = _preprocessCameraImage(image);
      print('Input tensor: $input');

      final output = List.filled(1 * 2024, 0.0).reshape([1, 2024]);

      print('Running model...');
      _interpreter?.run(input, output);
      print('Model run complete');

      final outputList = output[0].map((e) => e.toDouble()).toList();

      final predictedIndex = outputList.indexWhere(
              (element) => element == outputList.reduce((a, b) => a > b ? a : b));
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

      final output = List.filled(1 * 2024, 0.0).reshape([1, 2024]);

      print('Running model...');
      _interpreter?.run(input, output);
      print('Model run complete');

      final outputList = output[0].map((e) => e.toDouble()).toList();

      final predictedIndex = outputList.indexWhere((element) =>
      element == outputList.reduce((dynamic a, dynamic b) => a > b ? a : b));
      final String predictedName = labels[predictedIndex];
      final String predictedCalories = labelCaloriesMap[predictedName] ?? 'Unknown';
      final double confidence = outputList[predictedIndex];

      setState(() {
        _predictedLabel = '$predictedName - Calories: $predictedCalories';
        _confidence = confidence.toStringAsFixed(2);
      });

      widget.onFoodDetected(predictedName, predictedCalories, imageBytes);
    } catch (e) {
      print('Error running model on image: $e');
      setState(() {
        _predictedLabel = 'Error';
        _confidence = '0';
      });
    } finally {
      _isDetecting = false;
    }
  }


  img.Image _convertCameraImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final img.Image imgImage = img.Image(width, height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int pixelIndex = y * width + x;
        final int pixel = image.planes[0].bytes[pixelIndex];
        imgImage.setPixel(x, y, img.getColor(pixel, pixel, pixel));
      }
    }

    return imgImage;
  }

  List<List<List<List<int>>>> _preprocessCameraImage(CameraImage image) {
    final img.Image convertedImage = _convertCameraImage(image);
    final resizedImage = img.copyResize(convertedImage, width: 224, height: 224);
    final input = List.generate(
        1,
            (i) => List.generate(
            224, (j) => List.generate(224, (k) => List.generate(3, (l) => 0))));
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
    final input = List.generate(
        1,
            (i) => List.generate(
            224, (j) => List.generate(224, (k) => List.generate(3, (l) => 0))));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Object Detection'),
      ),
      body: Stack(
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              color: Colors.black.withOpacity(0.5),
              child: Text(
                'Detected: $_predictedLabel (Confidence: $_confidence)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_imageBytes != null) {
            widget.onFoodDetected(_predictedLabel, _confidence.toString(), _imageBytes!);
          }
          Navigator.pop(context); // Ensure the screen is popped after detection
        },
        child: Icon(Icons.check),
      ),
    );
  }
}