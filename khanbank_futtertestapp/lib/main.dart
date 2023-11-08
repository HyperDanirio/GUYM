import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SpeechToTextScreen(),
    );
  }
}

class SpeechToTextScreen extends StatefulWidget {
  @override
  _SpeechToTextScreenState createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = 'Дараад ярина уу';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    bool available = await _speech.initialize(
      onError: (error) => print('Error: $error'),
    );

    if (available) {
      _speech.listen(
        onResult: (result) => setState(() {
          _text = result.recognizedWords;
        }),
        localeId:
            'mn-MN', // Set the language code for Mongolian (Example 'mn-MN')
      );
    } else {
      print('The user denied the use of speech recognition.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff198C4D),
        title: Text('Khanbank'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_text),
            SizedBox(height: 20),
            FloatingActionButton(
              backgroundColor: Color(0xffff198C4D),
              onPressed: () {
                if (!_isListening) {
                  _speech.listen(
                    onResult: (result) => setState(() {
                      _text = result.recognizedWords;
                    }),
                    localeId:
                        'mn-MN', // Set the language code for Mongolian (Example 'mn-MN')
                  );
                } else {
                  _speech.stop();
                }
                setState(() {
                  _isListening = !_isListening;
                });
              },
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }
}
