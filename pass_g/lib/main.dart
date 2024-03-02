import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          color: Colors.blueGrey[900], // Background color of the app bar
          elevation: 0, // No shadow
          iconTheme: IconThemeData(color: Colors.white), // Icon color
        ),
        scaffoldBackgroundColor:
            Colors.blueGrey[100], // Background color of the app
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white70, // Background color of the text field
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: PasswordGenerator(),
    );
  }
}

class PasswordGenerator extends StatefulWidget {
  @override
  _PasswordGeneratorState createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator> {
  String _password = '';
  bool _loading = false;
  double _progressValue = 0.0;

  // Method for generating random passwords
  void _generatePassword() {
    final random = Random();
    final characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+';
    String password = '';
    for (int i = 0; i < 12; i++) {
      password += characters[random.nextInt(characters.length)];
    }
    setState(() {
      _loading = true;
      _progressValue = 0.0;
    });

    final progressChangeInterval = 0.1;
    final totalAnimationDuration = 2;

    Future.delayed(
        Duration(
            milliseconds:
                (totalAnimationDuration * 1000 * progressChangeInterval)
                    .round()), () {
      setState(() {
        _loading = false;
        _password = password;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'New password generated!',
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 2), // Adjust duration as needed
          backgroundColor: Colors.white,
        ),
      );
    });

    for (var i = 0;
        i < (totalAnimationDuration * 1000).round();
        i += (progressChangeInterval * 1000).round()) {
      Future.delayed(Duration(milliseconds: i), () {
        setState(() {
          _progressValue += progressChangeInterval;
        });
      });
    }
  }

  // Method for copying password to clipboard
  void _copyPassword() {
    Clipboard.setData(ClipboardData(text: _password));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password copied to clipboard'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Password Generator',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: AnimatedOpacity(
              opacity: _loading ? 0.5 : 1.0,
              duration: Duration(milliseconds: 200),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                      height:
                          20), // Added space between text field and "Your Password" text
                  Text(
                    'Your Password:',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight
                            .bold), // Increased font size and made bold
                  ),
                  SizedBox(
                      height:
                          10), // Added space between "Your Password" text and text field
                  // Displaying the password in a text field
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Generated Password',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: _password.isNotEmpty ? _copyPassword : null,
                      ),
                    ),
                    controller: TextEditingController(text: _password),
                    readOnly: true, // Prevent user input
                  ),
                  SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity: _loading ? 0.0 : 1.0,
                    duration: Duration(milliseconds: 180),
                    child: ElevatedButton(
                      onPressed: _generatePassword,
                      child: Text('Generate Password'),
                    ),
                  ),
                  SizedBox(height: 20),
                  AnimatedContainer(
                    duration: Duration(seconds: 2),
                    curve: Curves.linear,
                    height: _loading ? 4 : 0,
                    child: LinearProgressIndicator(
                      value: _progressValue,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
