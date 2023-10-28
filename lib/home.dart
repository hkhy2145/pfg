import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String url = '';
  var data;
  String output = 'Initial Output';

  // Define your Discord webhook URL
  final webhookUrl = 'https://discord.com/api/webhooks/1165290854416646225/NFI2Puw2SYeWNetzEm9sr_KtCSjEA-6CS54hTQZDCy7LD-EYLuv0rM2oioO7ObazFZvU';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Discord Webhook')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextField(
              onChanged: (value) {
                url = 'http://10.0.2.2:5000/api?query=' + value.toString();
              },
            ),
            TextButton(
              onPressed: () async {
                data = await fetchdata('https://api64.ipify.org?format=json');
                var decoded = jsonDecode(data);

                // Send a message to the Discord webhook
                await sendToDiscordWebhook('Message: ${decoded['output']}');

                setState(() {
                  output = 'Message sent to Discord!';
                });
              },
              child: Text(
                'Send Message to Discord',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Text(
              output,
              style: TextStyle(fontSize: 20, color: Colors.green),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> sendToDiscordWebhook(String message) async {
    final response = await http.post(
      Uri.parse(webhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'content': message}),
    );

    if (response.statusCode == 200) {
      print('Message sent to Discord successfully');
    } else {
      print('Failed to send message to Discord: ${response.statusCode}');
    }
  }

  // Your fetchdata and other methods go here
}
