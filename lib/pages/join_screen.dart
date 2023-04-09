import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:wep_rtc/models/meeting_details.dart';
import 'package:wep_rtc/pages/meeting_page.dart';

class JoinScreen extends StatefulWidget {
  final MeetingDetails? meetingDetails;

  const JoinScreen({super.key, this.meetingDetails});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  String userName = "";
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello world"),
      ),
      body: Form(key: globalKey, child: FormUI()),
    );
  }

  FormUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcom To WeoRTC"),
            const SizedBox(
              height: 20,
            ),
            FormHelper.inputFieldWidget(context, userName, "Enter your  Id ",
                (val) {
              if (val.isEmpty) {
                return "Please enter valied text ";
              } else {
                return null;
              }
            }, (save) {
              userName = save;
            }),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FormHelper.submitButton("join ", () {
                  if (valdateandsave()) {
                    //! meeting pase
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return MeetingPage(
                            meeting_id: widget.meetingDetails!.id!,
                            name: userName,
                            meetingDetails: widget.meetingDetails!);
                      },
                    ));
                  } else {}
                }),
              ],
            )
          ],
        ),
      ),
    );
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
