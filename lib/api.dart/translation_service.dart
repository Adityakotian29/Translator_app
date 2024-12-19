import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {

  final String apiUrl = "https://google-translate113.p.rapidapi.com/api/v1/translator/html";
  final String apiKey = "6a15ad78demshbb16779b10ef947p19c78djsne80326908a29";

 
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

  final String fromLanguageCode = languageCodeMap[fromLang] ?? 'en';  
  final String toLanguageCode = languageCodeMap[toLang] ?? 'en';    

  final url = Uri.parse(apiUrl);

  try {
  
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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);


      final translatedText = data['data']?['translations']?[0]?['translatedText'];

     
      return translatedText ?? 'Translation failed';
    } else {
   
      throw Exception("Translation failed: ${response.body}");
    }
  } catch (e) {

    throw Exception("Translation failed: $e");
  }
}
}
