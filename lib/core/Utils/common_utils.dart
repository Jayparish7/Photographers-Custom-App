import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CommonUtils {
  Future<String?> networkImageToBase64(String imageUrl) async {
    try {
      // Fetch the image from the network
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Get the image bytes
        Uint8List bytes = response.bodyBytes;
        // Encode bytes to Base64
        String base64String = base64Encode(bytes);
        return base64String;
      } else {
        print("Failed to load image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error converting network image to Base64: $e");
      return null;
    }
  }
}
