import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(DiscordWebhookApp());
}

class DiscordWebhookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DiscordWebhookScreen(),
    );
  }
}

class DiscordWebhookScreen extends StatefulWidget {
  @override
  _DiscordWebhookScreenState createState() => _DiscordWebhookScreenState();
}

class _DiscordWebhookScreenState extends State<DiscordWebhookScreen> {
  TextEditingController textController = TextEditingController();
  String outputMessage = '';

  final webhookUrl =
      'https://discord.com/api/webhooks/1165290854416646225/NFI2Puw2SYeWNetzEm9sr_KtCSjEA-6CS54hTQZDCy7LD-EYLuv0rM2oiooO7ObazFZvU';

  void sendToDiscord() async {
    String message = textController.text;
    var data = {'content': message};
    var response = await http.post(
      Uri.parse(webhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 204) {
      setState(() {
        outputMessage = 'Message sent to Discord successfully';
      });
    } else {
      setState(() {
        outputMessage = 'Failed to send message to Discord: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Discord Webhook Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: textController,
              decoration: InputDecoration(hintText: 'Enter your message'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendToDiscord,
              child: Text('Send Message to Discord'),
            ),
            SizedBox(height: 20),
            Text(
              outputMessage,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
