import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'dart:html' as html; // apenas para web

class VideoCallScreen extends StatelessWidget {
  final String userId;
  final String userName;
  final String callId;

  const VideoCallScreen({
    Key? key,
    required this.userId,
    required this.userName,
    required this.callId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Redireciona para Jitsi Meet ou outra plataforma
      html.window.location.href = "https://meet.jit.si/$callId";

      return const Scaffold(
        body: Center(
          child: Text(
            "Redirecionando para chamada de vídeo via navegador...",
            style: TextStyle(fontSize: 18, color: Colors.blue),
          ),
        ),
      );
    }

    // Se não for Web, usa Zego normalmente
    return Scaffold(
      appBar: AppBar(title: const Text("Video Chamada")),
      body: ZegoUIKitPrebuiltCall(
        appID: 1564283831,
        appSign: "c4b4f8382c14d3e29bb754c208a9b7fc0cb7593af28794f240aa73b0e1b47dbc",
        userID: userId,
        userName: userName,
        callID: callId,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      ),
    );
  }
}




