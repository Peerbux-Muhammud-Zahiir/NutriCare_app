import 'dart:typed_data';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class FoodClassification {
  late tfl.Interpreter interpreter;
  final ImagePicker _picker = ImagePicker();

  FoodClassification() {
    _initTensorFlow();
  }

  Future<void> _initTensorFlow() async {
    try {
      interpreter = await tfl.Interpreter.fromAsset('assets/foodpretrainedmodel.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Future<Map<String, dynamic>?> classifyImageFromSource(XFile image) async {
    final Uint8List imageBytes = await image.readAsBytes();
    return await _runModelOnImage(imageBytes, image.path);
  }

  Future<Map<String, dynamic>> _runModelOnImage(Uint8List imageBytes, String imagePath) async {
    try {
      img.Image image = img.decodeImage(imageBytes)!;
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

      var output = List.filled(1 * 2024, 0.0).reshape([1, 2024]);
      interpreter.run(input, output);

      final labelsAndCalories = await _loadLabelsAndCaloriesFromCsv('assets/foodpretrainedmodel2.csv');
      List<dynamic> cleanedOutput = output[0].map((e) => e.toDouble()).toList();

      double maxValue = double.negativeInfinity;
      int maxIndex = -1;

      for (int i = 0; i < cleanedOutput.length; i++) {
        if (cleanedOutput[i] > maxValue) {
          maxValue = cleanedOutput[i];
          maxIndex = i;
        }
      }

      if (maxValue > 25) {
        String predictedLabel = labelsAndCalories.keys.elementAt(maxIndex);
        String predictedCalories = labelsAndCalories[predictedLabel] ?? 'Unknown';
        return {'label': predictedLabel, 'calories': predictedCalories, 'imageBytes': imageBytes};
      } else {
        return {'error': 'Nothing detected'};
      }
    } catch (e) {
      print('Failed to run model on image: $e');
      return {'error': 'Failed to run model on image'};
    }
  }

  Future<Map<String, String>> _loadLabelsAndCaloriesFromCsv(String csvFilePath) async {
    try {
      final csvData = await rootBundle.loadString(csvFilePath);
      final lines = csvData.split('\n');
      final Map<String, String> labelsAndCalories = {};
      for (var i = 1; i < lines.length; i++) {
        final parts = lines[i].split(',');
        if (parts.length > 2) {
          labelsAndCalories[parts[1].trim()] = parts[2].trim();
        }
      }
      return labelsAndCalories;
    } catch (e) {
      print('Failed to load labels and calories from CSV: $e');
      return {};
    }
  }
}