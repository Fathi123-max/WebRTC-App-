import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
import 'package:wep_rtc/models/meeting_details.dart';
import 'package:wep_rtc/pages/home_screen.dart';
import 'package:wep_rtc/utlis/user.utlies.dart';
import 'package:wep_rtc/widgets/control_panal.dart';
import 'package:wep_rtc/widgets/remmote_connection.dart';

class MeetingPage extends StatefulWidget {
  final String meeting_id;
  final String name;
  final MeetingDetails meetingDetails;

  const MeetingPage(
      {super.key,
      required this.meeting_id,
      required this.name,
      required this.meetingDetails});

  @override
  State<MeetingPage> createState() => _MeetingState();
}

class _MeetingState extends State<MeetingPage> {
  final _localRenders = RTCVideoRenderer();
  final Map<String, dynamic> mediaConstraints = <String, dynamic>{
    'audio': true,
    'video': true,
  };
  bool isConnectedFaild = false;
  WebRTCMeetingHelper? meettingHelper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildMeetingRoom(),
      bottomNavigationBar: ControlPanal(
        onAudioToggle: onAudioToggle,
        onVideoToggle: onVideoToggle,
        onReConnected: onReConnected,
        onMettingEnd: onMettingEnd,
        audio_enabled: isaudio_enabled(),
        video_enabled: isvideo_enabled(),
        isConnectedFaild: isConnectedFaild,
      ),
    );
  }

  void startMetting() async {
    final userid = await loadUserId();
    meettingHelper = WebRTCMeetingHelper(
      meetingId: widget.meeting_id,
      userId: userid,
      name: widget.name,
    );
    MediaStream _localStream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenders.setSrcObject(stream: _localStream);
    meettingHelper!.stream = _localStream;

    meettingHelper!.on("open", context, (ev, context) {
      setState(() {
        isConnectedFaild = false;
      });
    });

    meettingHelper!.on("connection", context, (ev, context) {
      setState(() {
        isConnectedFaild = false;
      });
    });

    meettingHelper!.on("User-left", context, (ev, context) {
      setState(() {
        isConnectedFaild = false;
      });
    });
    meettingHelper!.on("video_toggle", context, (ev, context) {
      setState(() {
        isConnectedFaild = false;
      });
    });
    meettingHelper!.on("audio_toggle", context, (ev, context) {
      setState(() {
        onMeetingEnded();
      });
    });
    meettingHelper!.on("metting_ended", context, (ev, context) {
      setState(() {
        isConnectedFaild = false;
      });
    });
    meettingHelper!.on("connection-sitting-changed", context, (ev, context) {
      setState(() {
        isConnectedFaild = false;
      });
    });
    meettingHelper!.on("stream-changed", context, (ev, context) {
      setState(() {
        isConnectedFaild = false;
      });
    });

    setState(() {});
  }

  iniRenders() async {
    _localRenders.initialize();
  }

  @override
  void initState() {
    super.initState();
    iniRenders();
    startMetting();
  }

  @override
  void deactivate() {
    super.deactivate();
    _localRenders.dispose();
    if (meettingHelper != null) {
      meettingHelper!.destroy();
      meettingHelper = null;
    } else {}
  }

  void onMeetingEnded() {}

  bool isaudio_enabled() {
    return meettingHelper != null ? meettingHelper!.videoEnabled! : false;
  }

  bool isvideo_enabled() {
    return meettingHelper != null ? meettingHelper!.audioEnabled! : false;
  }

  onMettingEnd() {
    if (meettingHelper != null) {
      meettingHelper!.endMeeting();
      meettingHelper = null;
      gotoHomePage();
    } else {}
  }

  onReConnected() {
    if (meettingHelper != null) {
      meettingHelper!.reconnect();
    } else {}
  }

  onVideoToggle() {
    if (meettingHelper != null) {
      setState(() {
        meettingHelper!.toggleVideo();
      });
    } else {}
  }

  onAudioToggle() {
    if (meettingHelper != null) {
      setState(() {
        meettingHelper!.toggleAudio();
      });
    } else {}
  }

  _buildMeetingRoom() {
    return Stack(
      children: [
        meettingHelper != null && meettingHelper!.connections.isNotEmpty
            ? GridView.count(
                crossAxisCount: meettingHelper!.connections.length < 3 ? 1 : 2,
                children: List.generate(
                  meettingHelper!.connections.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.all(1),
                      child: RemoteConnection(
                          renderer: meettingHelper!.connections[index].renderer,
                          connection: meettingHelper!.connections[index]),
                    );
                  },
                ),
              )
            : const Center(
                child: Text("Wating for users to join the Metting "),
              ),
        Positioned(
            child: SizedBox(
          child: RTCVideoView(_localRenders),
        ))
      ],
    );
  }

  void gotoHomePage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const HomePage(),
    ));
  }
}
