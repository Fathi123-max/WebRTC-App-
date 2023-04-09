import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:wep_rtc/api/metting_api.dart';
import 'package:wep_rtc/models/meeting_details.dart';
import 'package:wep_rtc/pages/Join_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String meeting_id = "";
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello world"),
      ),
      body: Form(key: globalKey, child: FormUI()),
    );
  }

  FormUI() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcom To WeoRTC"),
            SizedBox(
              height: 20,
            ),
            FormHelper.inputFieldWidget(context, meeting_id, "Enter your  Id ",
                (val) {
              if (val.isEmpty) {
                return "Please enter valied text ";
              } else {
                return null;
              }
            }, (save) {
              meeting_id = save;
            }),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FormHelper.submitButton("join Meeting", () {
                  if (valdateandsave()) {
                    valdateMeeingId(meeting_id);
                  } else {}
                }),
                FormHelper.submitButton("Start meeting ", () async {
                  var response = await startMeeting();
                  final body = json.decode(response.body);
                  final meeting_id = body["data"];

                  valdateMeeingId(meeting_id);
                })
              ],
            )
          ],
        ),
      ),
    );
  }

  void valdateMeeingId(String meeting_id) async {
    try {
      var response = await joinMeeting(meeting_id);
      final data = json.decode(response.body);

      final meetingDetails = MeetingDetails.fromJson(data["data"]);

      goinMettingScreen(meetingDetails);
    } catch (e) {
      FormHelper.showSimpleAlertDialog(
          context, "Meeting App", " InvaildMeeting Id", "ok", () {
        Navigator.of(context).pop();
      });
    }
  }

  goinMettingScreen(MeetingDetails meetingDetails) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => JoinScreen(meetingDetails: meetingDetails)));
  }

  valdateandsave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
