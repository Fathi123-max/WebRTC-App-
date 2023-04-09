import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wep_rtc/utlis/user.utlies.dart';

// get from  node js
String Metting_api = "http://192.168.1.6:4000/api/metting";

var client = http.Client();
Future<http.Response> startMeeting() async {
  Map<String, String> requestHeaders = {"Content-Type": "application/json"};

  var userId = await loadUserId();

  var response = await client.post(
    Uri.parse("$Metting_api/start"),
    headers: requestHeaders,
    body: jsonEncode(
      {"hostId": userId, "hostName": ""},
    ),
  );

  if (response.statusCode == 200) {
    return response;
  } else {
    return response;
  }
}

Future<http.Response> joinMeeting(String MeetingId) async {
  var response =
      await http.get(Uri.parse("$MeetingId/join?meetingId=$MeetingId"));

  if (response.statusCode >= 200 && response.statusCode < 400) {
    return response;
  }
  throw UnsupportedError("Not a Vaild Meeting");
}
