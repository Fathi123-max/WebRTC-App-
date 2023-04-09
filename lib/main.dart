import 'package:flutter/material.dart';
import 'package:wep_rtc/models/meeting_details.dart';
import 'package:wep_rtc/pages/meeting_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MeetingPage(
          meeting_id: "home", name: "fgd", meetingDetails: MeetingDetails()),
      debugShowCheckedModeBanner: false,
    );
  }
}
