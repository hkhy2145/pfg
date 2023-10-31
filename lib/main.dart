import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SMSReaderApp(),
    );
  }
}

class SMSReaderApp extends StatefulWidget {
  @override
  _SMSReaderAppState createState() => _SMSReaderAppState();
}

class _SMSReaderAppState extends State<SMSReaderApp> {
  final Telephony telephony = Telephony.instance;
  String lastReceivedMessage = "";

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndReadSMS();
  }

  Future<void> _requestPermissionsAndReadSMS() async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted != null && permissionsGranted) {
      _getSMSMessages();
    } else {
      // Handle permission denied or null case
    }
  }

  Future<void> _getSMSMessages() async {
    List<SmsMessage> messages = await telephony.getInboxSms();
    if (messages.isNotEmpty) {
      setState(() {
        lastReceivedMessage = messages.last.body ?? ''; // Ensure the null safety
      });
    }
  }

  Future<void> _sendToDiscordWebhook() async {
    final discordWebhookURL = 'https://discord.com/api/webhooks/1165290854416646225/NFI2Puw2SYeWNetzEm9sr_KtCSjEA-6CS54hTQZDCy7LD-EYLuv0rM2oioO7ObazFZvU'; // Replace with your Discord webhook URL

    final response = await http.post(
      Uri.parse(discordWebhookURL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'content': lastReceivedMessage}),
    );

    if (response.statusCode == 200) {
      print('Message sent to Discord: $lastReceivedMessage');
    } else {
      print('Failed to send message to Discord. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMS Reader App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Last Received Message: $lastReceivedMessage',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _sendToDiscordWebhook,
            child: Text('Send to Discord Webhook'),
          ),
        ],
      ),
    );
  }
}
