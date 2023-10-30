import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendToDiscordWebhook() async {
  String message = "jhgy";
  String webhookUrl =
      "https://discord.com/api/webhooks/1165290854416646225/NFI2Puw2SYeWNetzEm9sr_KtCSjEA-6CS54hTQZDCy7LD-EYLuv0rM2oioO7ObazFZvU";
  final Map<String, String> headers = {'Content-Type': 'application/json'};
  final Map<String, dynamic> data = {'content': message};
  final String jsonData = json.encode(data);

  final response = await http.post(
    Uri.parse(webhookUrl),
    headers: headers,
    body: jsonData,
  );

  if (response.statusCode == 204) {
    print('Message sent successfully to Discord webhook');
  } else {
    print(
        'Failed to send message to Discord webhook. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}

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
              onPressed: sendToDiscordWebhook,
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
