import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class ControlPanal extends StatelessWidget {
  final bool? video_enabled;
  final bool? audio_enabled;
  final bool isConnectedFaild;
  final VoidCallback? onVideoToggle;
  final VoidCallback? onAudioToggle;
  final VoidCallback? onReConnected;
  final VoidCallback? onMettingEnd;

  ControlPanal(
      {super.key,
      this.video_enabled,
      this.audio_enabled,
      required this.isConnectedFaild,
      this.onVideoToggle,
      this.onAudioToggle,
      this.onReConnected,
      this.onMettingEnd});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: BuildControl()),
    );
  }

  List<Widget> BuildControl() {
    if (isConnectedFaild) {
      return <Widget>[
        IconButton(
            onPressed: onVideoToggle,
            icon: Icon(video_enabled! ? Icons.videocam : Icons.videocam_off)),
        IconButton(
            onPressed: onAudioToggle,
            icon: Icon(audio_enabled! ? Icons.mic : Icons.mic_off)),
        SizedBox(
          width: 25,
        ),
        Container(
          width: 70,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: IconButton(
            onPressed: onMettingEnd,
            icon: Icon(Icons.call_end),
          ),
        ),
      ];
    } else {
      return <Widget>[
        FormHelper.submitButton(
          "Reconnect",
          onReConnected!,
        )
      ];
    }
  }
}
