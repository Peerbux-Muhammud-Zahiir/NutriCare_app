import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:image/image.dart' as img;

class FoodClassification extends StatefulWidget {
  const FoodClassification({super.key});

  @override
  State<FoodClassification> createState() => _FoodClassificationState();
}

class _FoodClassificationState extends State<FoodClassification> {
  late tfl.Interpreter interpreter;
  String _predictedLabel = ''; // Variable to store the predicted label
  Uint8List? _resizedImageBytes; // Variable to store the resized image bytes

  @override
  void initState() {
    super.initState();
    _initTensorFlow();
  }

  @override
  void dispose() {
    interpreter.close();
    super.dispose();
  }

  Future<void> _initTensorFlow() async {
    try {
      interpreter = await tfl.Interpreter.fromAsset('assets/foodpretrainedmodel.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Uint8List imageToByteListUint8(Uint8List imageBytes, int width, int height, int channels) {
    // Decode the image
    img.Image image = img.decodeImage(imageBytes)!;

    // Resize the image
    img.Image resizedImage = img.copyResize(image, width: width, height: height);

    // Create a byte buffer with the required size
    var buffer = Uint8List(width * height * channels);

    // Fill the buffer with normalized pixel values
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int pixel = resizedImage.getPixel(x, y);
        buffer[(y * width + x) * channels + 0] = (img.getRed(pixel) / 255.0).toInt();
        buffer[(y * width + x) * channels + 1] = (img.getGreen(pixel) / 255.0).toInt();
        buffer[(y * width + x) * channels + 2] = (img.getBlue(pixel) / 255.0).toInt();
      }
    }

    return buffer;
  }

  Future<void> FileImageRecognition() async {
    try {
      // Load the image from assets
      ByteData imageData = await rootBundle.load('assets/biryani.jpg');
      Uint8List imageBytes = imageData.buffer.asUint8List();
      img.Image image = img.decodeImage(imageBytes)!;

      // Preprocess the image to match the input tensor shape and type
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);
      var input = List.generate(1, (i) => List.generate(224, (j) => List.generate(224, (k) => List.generate(3, (l) => 0))));
      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          var pixel = resizedImage.getPixel(x, y);
          input[0][y][x][0] = img.getRed(pixel);
          input[0][y][x][1] = img.getGreen(pixel);
          input[0][y][x][2] = img.getBlue(pixel);
        }
      }

      // Convert resized image to bytes for display
      Uint8List resizedImageBytes = Uint8List.fromList(img.encodeJpg(resizedImage));

      // Define output tensor with shape [1, 2024] and type float32
      var output = List.filled(1 * 2024, 0.0).reshape([1, 2024]);

      // Run inference
      interpreter.run(input, output);

      // Print the output
      print(output);

      // Load labels directly from CSV
      final labels = await _loadLabelsFromCsv('assets/foodpretrainedmodel.csv');

      // Debug print: Contents of the labels list
      print('Labels: $labels');

      // Find the index of the highest value in the output tensor
      List<dynamic> cleanedOutput = output[0].map((e) => e.toDouble()).toList();

      double maxValue = double.negativeInfinity; // Initialize maxValue with a very small value
      int maxIndex = -1; // Initialize maxIndex with -1

      // Iterate through the cleaned output tensor to find the highest confidence value and its index
      for (int i = 0; i < cleanedOutput.length; i++) {
        if (cleanedOutput[i] > maxValue) {
          maxValue = cleanedOutput[i] as double;
          maxIndex = i;
        }
      }

      // Set the predicted label and resized image bytes based on the confidence value
      setState(() {
        if (maxValue > 150) {
          _predictedLabel = labels[maxIndex];
        } else {
          _predictedLabel = 'nothing detected'; // or 'No prediction' if you prefer
        }
        _resizedImageBytes = resizedImageBytes;
      });

      // Debug print: Highest value and index
      print('Highest value: $maxValue at index: $maxIndex');
    } catch (e) {
      print('Failed to run model on image: $e');
    }
  }

  Future<List<String>> _loadLabelsFromCsv(String csvFilePath) async {
    try {
      // Load the CSV file
      final csvData = await rootBundle.loadString(csvFilePath);

      // Parse the CSV data
      final lines = csvData.split('\n');
      final labels = <String>[];
      for (var i = 1; i < lines.length; i++) { // Skip the first line (header)
        final parts = lines[i].split(',');
        if (parts.length > 1) {
          labels.add(parts[1].trim());
        }
      }
      return labels;
    } catch (e) {
      print('Failed to load labels from CSV: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Classification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: FileImageRecognition,
              child: Text('Run Model'),
            ),
            SizedBox(height: 20),
            Text(
              'Predicted Label: $_predictedLabel',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            _resizedImageBytes != null
                ? Image.memory(_resizedImageBytes!)
                : Container(),
          ],
        ),
      ),
    );
  }
}