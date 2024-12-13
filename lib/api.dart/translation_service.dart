import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  // Corrected API URL
  final String apiUrl = "https://google-translate113.p.rapidapi.com/api/v1/translator/html";
  final String apiKey = "6a15ad78demshbb16779b10ef947p19c78djsne80326908a29";

  // Create a map to convert language names to their corresponding language codes
  final Map<String, String> languageCodeMap = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Italian': 'it',
    'Portuguese': 'pt',
    'Russian': 'ru',
    'Japanese': 'ja',
    'Chinese (Simplified)': 'zh',
    'Arabic': 'ar',
  };

Future<String> translateText(String text, String fromLang, String toLang) async {
  // Get language codes from the language names, defaulting to 'en' if not found
  final String fromLanguageCode = languageCodeMap[fromLang] ?? 'en';  
  final String toLanguageCode = languageCodeMap[toLang] ?? 'en';    

  final url = Uri.parse(apiUrl);

  try {
    // Making the API request
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "X-RapidAPI-Key": apiKey,
        "X-RapidAPI-Host": "google-translate1.p.rapidapi.com",
      },
      body: jsonEncode({
        'q': text,
        'source': fromLanguageCode,
        'target': toLanguageCode,
      }),
    );

    // If the response status is 200 (OK), process the data
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Safely access the response data, using null-aware operators
      final translatedText = data['data']?['translations']?[0]?['translatedText'];

      // If translatedText is null, return a default message or empty string
      return translatedText ?? 'Translation failed';
    } else {
      // If the API request was not successful, throw an exception
      throw Exception("Translation failed: ${response.body}");
    }
  } catch (e) {
    // Catch any error during the API call or JSON processing
    throw Exception("Translation failed: $e");
  }
}
}
