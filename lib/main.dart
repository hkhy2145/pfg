import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

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
