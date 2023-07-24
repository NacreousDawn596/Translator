import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Funny Translator LOL',
      theme: ThemeData(
        brightness: Brightness.dark, // Set the theme to dark
        primaryColor: Color(0xFF000000), // Background color
        scaffoldBackgroundColor: Color(0xFF000000),
        canvasColor: Color(0xFF1D1D1F), // Surface color
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Color(0xFFF5F5F7)), // Set text color to off-white
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF1D1D1F), // Set button background color to dark gray
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xFFF5F5F7)), // Set label color to off-white
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFF5F5F7)), // Set border color to off-white
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      home: DataFetchingScreen(),
    );
  }
}

class DataFetchingScreen extends StatefulWidget {
  @override
  _DataFetchingScreenState createState() => _DataFetchingScreenState();
}

class _DataFetchingScreenState extends State<DataFetchingScreen> {
  String _responseData = '';
  String _selectedMethod = 'pirate';
  TextEditingController _textController = TextEditingController();

  final List<String> _translationMethods = [
    "english", "morse", "valspeak", "jive", "cockney", "brooklyn", "ermahgerd", "pirate", "minion", "ferblatin",
    "chef", "dolan", "fudd", "braille", "sindarin", "quneya", "oldenglish", "shakespeare", "us2uk", "uk2us",
    "dothraki", "valyrian", "vulcan", "klingon", "piglatin", "sith", "cheunh", "gungan", "mandalorian", "huttese",
  ];

  void _fetchData() async {
    setState(() {
      _responseData = 'Translating...';
    });

    String inputText = _textController.text;
    String translationMethod = _selectedMethod;

    if (inputText.isNotEmpty) {
      try {
        final response = await _translateText(inputText, translationMethod);
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          setState(() {
            _responseData = responseData['contents']['translated'];
          });
        } else {
          setState(() {
            _responseData = 'Failed to translate text. Status Code: ${response.statusCode}';
          });
        }
      } catch (error) {
        setState(() {
          _responseData = 'Error: $error';
        });
      }
    }
  }

  Future<http.Response> _translateText(String text, String method) {
    String apiUrl = "https://api.funtranslations.com/translate/$method?text=$text";
    return http.get(Uri.parse(apiUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Funny Translator LOL'),
      ),
      body: Center( // Center the content vertically and horizontally
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Enter Text',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedMethod,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedMethod = newValue!;
                      });
                    },
                    items: _translationMethods.map((method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            method,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _fetchData,
              child: Text('Translate!!'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _responseData,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}