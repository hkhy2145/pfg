import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final webhookUrl = 'https://discord.com/api/webhooks/1165290854416646225/NFI2Puw2SYeWNetzEm9sr_KtCSjEA-6CS54hTQZDCy7LD-EYLuv0rM2oioO7ObazFZvU';

  Future<void> sendMessageToDiscord() async {
    final response = await http.post(
      Uri.parse(webhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'content': 'Hello, World!'}),
    );

    if (response.statusCode == 200) {
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        output = 'Goodbye, World!';
      });
    } else {
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        output = 'Not Good';
      });
    }
  }

  String output = 'Initial Output';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Discord Webhook Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              output,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendMessageToDiscord,
              child: Text('Send Message to Discord'),
            ),
          ],
        ),
      ),
    );
  }
}
