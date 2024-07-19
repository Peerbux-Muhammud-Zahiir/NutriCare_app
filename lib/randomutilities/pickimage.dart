import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  } else {
    const String defaultImageUrl = 'https://example.com/default-image.jpg';
    final response = await http.get(Uri.parse(defaultImageUrl));
    return response.bodyBytes;
  }
}