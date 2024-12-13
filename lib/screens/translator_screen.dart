import 'package:flutter/material.dart';
import 'package:language_translator/api.dart/translation_service.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TranslatorState();
  }
}

class _TranslatorState extends State<TranslatorScreen> {
  String language_1 = 'Select Language';
  String language_2 = 'Select Language';
  String translatedText = '';
  String inputText = '';
  bool isLoading = false;  // Add a variable to track loading state

  final TranslationService translationService = TranslationService();

  final List<String> languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Russian',
    'Japanese',
    'Chinese (Simplified)',
    'Arabic'
  ];

  // Function to translate text when the button is clicked
  void _translate() async {
    if (language_1 == 'Select Language' || language_2 == 'Select Language') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both languages')),
      );
      return;
    }

    setState(() {
      isLoading = true;  // Set loading to true when translation starts
    });

    try {
      final result = await translationService.translateText(
        inputText,
        language_1,  // language_1 is the name, will be mapped in TranslationService
        language_2,  // language_2 is the name, will be mapped in TranslationService
      );
      setState(() {
        translatedText = result;
        isLoading = false;  // Set loading to false when translation finishes
      });
    } catch (e) {
      setState(() {
        isLoading = false;  // Set loading to false if an error occurs
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Function to open bottom sheet for "From Language"
  void _openBottomSheet_from() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: languages.map((lang) {
                  return ListTile(
                    title: Text(lang),
                    onTap: () {
                      setState(() {
                        language_1 = lang;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  // Function to open bottom sheet for "To Language"
  void _openBottomSheet_to() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: languages.map((lang) {
                  return ListTile(
                    title: Text(lang),
                    onTap: () {
                      setState(() {
                        language_2 = lang;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translator App'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _openBottomSheet_from,
              child: Text(language_1),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              autocorrect: true,
              onChanged: (value) {
                setState(() {
                  inputText = value;
                });
              },
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(hintText: 'ENTER TEXT'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Center(
            child: ElevatedButton(
              onPressed: _openBottomSheet_to,
              child: Text(language_2),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              autocorrect: true,
              controller: TextEditingController(text: translatedText),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(hintText: 'TRANSLATED TEXT'),
              readOnly: true,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Center(
            child: isLoading
                ? CircularProgressIndicator()  // Show loading indicator while translating
                : ElevatedButton(
                    onPressed: _translate,  // Trigger the translation here
                    child: const Text('Translate'),
                  ),
          ),
        ],
      ),
    );
  }
}
