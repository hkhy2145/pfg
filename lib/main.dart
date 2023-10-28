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
      home: DiscordWebhookApp(),
    );
  }
}

class DiscordWebhookApp extends StatefulWidget {
  @override
  _DiscordWebhookAppState createState() => _DiscordWebhookAppState();
}

class _DiscordWebhookAppState extends State<DiscordWebhookApp> {
  TextEditingController textEditingController = TextEditingController();
  String outputText = '';

  void sendToDiscord() async {
    String message = textEditingController.text;
    String webhookUrl = "https://discord.com/api/webhooks/1165290854416646225/NFI2Puw2SYeWNetzEm9sr_KtCSjEA-6CS54hTQZDCy7LD-EYLuv0rM2oioO7ObazFZvU";

    Map<String, String> data = {"content": message};

    final response = await http.post(
      Uri.parse(webhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 204) {
      setState(() {
        outputText = "Message sent to Discord successfully";
      });
    } else {
      setState(() {
        outputText = "Failed to send message to Discord: ${response.statusCode}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Discord Webhook App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(hintText: "Enter your message"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendToDiscord,
              child: Text('Send to Discord'),
            ),
            SizedBox(height: 20),
            Text(outputText),
          ],
        ),
      ),
    );
  }
}
