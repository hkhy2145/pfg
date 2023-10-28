import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HelloWorldApp(),
    );
  }
}

class HelloWorldApp extends StatefulWidget {
  @override
  _HelloWorldAppState createState() => _HelloWorldAppState();
}

class _HelloWorldAppState extends State<HelloWorldApp> {
  final webhookUrl =
      'YOUR_DISCORD_WEBHOOK_URL'; // Replace with your Discord webhook URL
  String message = 'Hello, World!';
  String displayMessage = '';

  @override
  void initState() {
    super.initState();
    sendMessageToWebhook();
  }

  void sendMessageToWebhook() async {
    await sendToDiscordWebhook(message);
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      displayMessage = 'Goodbye, World!';
    });
  }

  Future<void> sendToDiscordWebhook(String message) async {
    final response = await http.post(
      Uri.parse(webhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'content': message}),
    );

    if (response.statusCode == 200) {
      print('Message sent to Discord successfully');
    } else {
      print('Failed to send message to Discord: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello World App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              displayMessage,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
